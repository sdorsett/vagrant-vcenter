module VagrantPlugins
  module VCenter
    module Action
      class Suspend
        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new('vagrant_vcenter::action::suspend')
        end

        def call(env)
          config = env[:machine].provider_config
          dc = config.vcenter_cnx.serviceInstance.find_datacenter(config.datacenter_name) or abort 'datacenter not found'
          root_vm_folder = dc.vmFolder
          vm = root_vm_folder.findByUuid(env[:machine].id)

          # Poweroff VM
          env[:ui].info('Suspending VM...')
          vm.SuspendVM_Task.wait_for_completion

          @app.call env
        end
      end
    end
  end
end
