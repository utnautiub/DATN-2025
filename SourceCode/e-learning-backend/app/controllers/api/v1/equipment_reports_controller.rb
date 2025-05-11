# app/controllers/api/v1/equipment_reports_controller.rb
module Api
  module V1
    class EquipmentReportsController < Api::BaseController
      before_action :require_admin_schools, except: [ :create ]

      def index
        reports = EquipmentReport.joins(equipment_item: { room_equipment: { room: :building } })
                                .where(equipment_items: { room_equipments: { rooms: { buildings: { school_id: @current_user.school_id } } } })
                                .includes({ equipment_item: { room_equipment: { room: :building } } }, :user)

        respond_with_collection(reports, include: {
          equipment_item: {
            include: {
              room_equipment: {
                include: {
                  room: {
                    include: {
                      building: { only: [ :id, :name ] }
                    },
                    only: [ :id, :name ]
                  }
                }
              }
            },
            only: [ :id, :code, :status ]
          },
          user: { only: [ :id, :username ] }
        })
      end

      def create
        equipment_item = EquipmentItem.joins(room_equipment: { room: :building })
                                     .find_by(id: equipment_report_params[:equipment_item_id],
                                              room_equipments: {
                                                rooms: {
                                                  buildings: {
                                                    school_id: @current_user.school_id
                                                  }
                                                }
                                              })
        unless equipment_item
          respond_with_errors("Equipment item not found or does not belong to your school")
          return
        end

        report = EquipmentReport.new(equipment_report_params.merge(user_id: @current_user.id))
        if report.save
          respond_with_resource(report, {
            include: {
              equipment_item: {
                include: {
                  room_equipment: {
                    include: {
                      room: {
                        include: {
                          building: { only: [ :id, :name ] }
                        },
                        only: [ :id, :name ]
                      }
                    }
                  }
                },
                only: [ :id, :code, :status ]
              },
              user: { only: [ :id, :username ] }
            }
          }, :created)
        else
          respond_with_errors(report.errors.full_messages)
        end
      end

      def update
        report = find_report_by_id(params[:id])

        if report&.update(equipment_report_params)
          respond_with_resource(report, {
            include: {
              equipment_item: {
                include: {
                  room_equipment: {
                    include: {
                      room: {
                        include: {
                          building: { only: [ :id, :name ] }
                        },
                        only: [ :id, :name ]
                      }
                    }
                  }
                },
                only: [ :id, :code, :status ]
              },
              user: { only: [ :id, :username ] }
            }
          })
        else
          respond_with_errors(report ? report.errors.full_messages : [ "Report not found" ])
        end
      end

      def destroy
        report = find_report_by_id(params[:id])

        if report
          report.destroy
          respond_with_no_content
        else
          respond_with_errors([ "Report not found" ], :not_found)
        end
      end

      private

      def find_report_by_id(id)
        EquipmentReport.joins(equipment_item: { room_equipment: { room: :building } })
                        .where(id: id, equipment_items: {
                          room_equipments: {
                            rooms: {
                              buildings: {
                                school_id: @current_user.school_id
                              }
                            }
                          }
                        })
                        .includes({ equipment_item: { room_equipment: { room: :building } } }, :user)
                        .first
      end

      def equipment_report_params
        params.permit(:equipment_item_id, :description, :status)
      end

      def model_class
        EquipmentReport
      end
    end
  end
end
