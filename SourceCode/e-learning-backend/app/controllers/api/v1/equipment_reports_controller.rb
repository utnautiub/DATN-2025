# app/controllers/api/v1/equipment_reports_controller.rb
module Api
  module V1
    class EquipmentReportsController < ApplicationController
      before_action :authenticate_user
      before_action :require_admin_schools, except: [:create]

      def index
        reports = EquipmentReport.joins(equipment_item: { room_equipment: { room: :building } })
                                .where(equipment_items: { room_equipments: { rooms: { buildings: { school_id: @current_user.school_id } } } })
                                .includes({ equipment_item: { room_equipment: { room: :building } } }, :user) # Sửa cú pháp
        render json: reports.as_json(include: { 
          equipment_item: { 
            include: { 
              room_equipment: { 
                include: { 
                  room: { 
                    include: { 
                      building: { only: [:id, :name] } 
                    }, 
                    only: [:id, :name] 
                  } 
                } 
              } 
            }, 
            only: [:id, :code, :status] 
          },
          user: { only: [:id, :username] }
        })
      end

      def create
        equipment_item = EquipmentItem.joins(room_equipment: { room: :building })
                                     .find_by(id: equipment_report_params[:equipment_item_id], room_equipments: { rooms: { buildings: { school_id: @current_user.school_id } } })
        unless equipment_item
          render json: { error: 'Equipment item not found or does not belong to your school' }, status: :unprocessable_entity
          return
        end

        report = EquipmentReport.new(equipment_report_params.merge(user_id: @current_user.id))
        if report.save
          render json: report.as_json(include: { 
            equipment_item: { 
              include: { 
                room_equipment: { 
                  include: { 
                    room: { 
                      include: { 
                        building: { only: [:id, :name] } 
                      }, 
                      only: [:id, :name] 
                    } 
                  } 
                } 
              }, 
              only: [:id, :code, :status] 
            },
            user: { only: [:id, :username] }
          }), status: :created
        else
          render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        report = EquipmentReport.joins(equipment_item: { room_equipment: { room: :building } })
                               .where(equipment_items: { room_equipments: { rooms: { buildings: { school_id: @current_user.school_id } } } })
                               .includes({ equipment_item: { room_equipment: { room: :building } } }, :user) # Sửa cú pháp
        if report.update(equipment_report_params)
          render json: report.as_json(include: { 
            equipment_item: { 
              include: { 
                room_equipment: { 
                  include: { 
                    room: { 
                      include: { 
                        building: { only: [:id, :name] } 
                      }, 
                      only: [:id, :name] 
                    } 
                  } 
                } 
              }, 
              only: [:id, :code, :status] 
            },
            user: { only: [:id, :username] }
          })
        else
          render json: { errors: report.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        report = EquipmentReport.joins(equipment_item: { room_equipment: { room: :building } })
                               .where(equipment_items: { room_equipments: { rooms: { buildings: { school_id: @current_user.school_id } } } })
                               .includes({ equipment_item: { room_equipment: { room: :building } } }, :user) # Sửa cú pháp
        report.destroy
        head :no_content
      end

      private

      def equipment_report_params
        params.permit(:equipment_item_id, :description, :status)
      end

      def authenticate_user
        token = request.headers['Authorization']&.split(' ')&.last
        begin
          decoded = JWT.decode(token, 'your_secret_key', true, algorithm: 'HS256')
          @current_user = User.find(decoded[0]['user_id'])
        rescue
          render json: { error: 'Unauthorized' }, status: :unauthorized
        end
      end

      def require_admin_schools
        render json: { error: 'Forbidden' }, status: :forbidden unless @current_user.role == 'AdminSchools'
      end
    end
  end
end