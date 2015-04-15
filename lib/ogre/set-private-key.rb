require 'vcoworkflows'

module Ogre
  class SetPrivateKey < Thor::Group
    include Thor::Actions

    # required
    argument :chef_hostname, type: :string, desc: DESC_CHEF_HOSTNAME
    argument :chef_validator_name, type: :string, desc: DESC_CHEF_VALIDATOR
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # vcenter orchestrator options
    class_option :vco_url, type: :string, desc: DESC_VCO_URL
    class_option :vco_user, tydpe: :string, desc: DESC_VCO_USER
    class_option :vco_password, type: :string, desc: DESC_VCO_PASSWORD
    class_option :vco_wf_name, type: :string, desc: DESC_VCO_WF_NAME
    class_option :vco_verify_ssl, type: :boolean, default: true, desc: DESC_VCO_WF_NAME

    def set_private_key
      # get workflow
      workflow = VcoWorkflows::Workflow.new(options[:vco_wf_name] || VCO_WF_NAME,
                                             url: options[:vco_url] || VCO_URL,
                                             verify_ssl: false,
                                             username: options[:vco_user] || VCO_USER,
                                             password: options[:vco_password] || VCO_PASSWORD)

      # set parameters
      workflow.parameter('chefHostname', chef_hostname)
      workflow.parameter('userid', chef_validator_name)
      workflow.parameter('pem', File.read(key_path))

      # run workflow
      execution_id = workflow.execute

      # check status
      finished = false
      until finished
        sleep 5
        # Fetch a new workflow token to check the status of the workflow execution
        wf_token = workflow.token
        # If the execution is no longer alive, exit the loop
        unless wf_token.alive?
          finished = true
          execution_id
        end
      end

      # output result
      log = workflow.token(execution_id).to_s
      puts log.slice(0..log.index('Input Parameters:')-2)

    end
  end
end


