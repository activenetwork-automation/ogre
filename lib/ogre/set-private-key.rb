require 'vcoworkflows'

module Ogre
  # Set Private Key is used to set a chef validation key via a vco workflow
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
    class_option :vco_verify_ssl, type: :boolean, desc: DESC_VCO_WF_NAME

    # rubocop:disable CyclomaticComplexity, PerceivedComplexity
    # Execute vcoworkflows gem to call set private key
    def set_private_key
      # get workflow
      # rubocop:disable AlignParameters
      workflow = VcoWorkflows::Workflow.new(options[:vco_wf_name]    || Config.options[:vco_wf_name],
                                url:        options[:vco_url]        || Config.options[:vco_url],
                                verify_ssl: options[:vco_verify_ssl] || YAML.load(Config.options[:vco_verify_ssl]),
                                username:   options[:vco_user]       || Config.options[:vco_user],
                                password:   options[:vco_password]   || Config.options[:vco_password])
      # rubocop:enable AlignParameters

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
      puts log.slice(0..log.index('Input Parameters:') - 2)
    end
    # rubocop:enable CyclomaticComplexity, PerceivedComplexity
  end
end
