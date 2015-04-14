require 'vcoworkflows'

module Ogre
  class SetPrivateKey < Thor::Group
    include Thor::Actions
    argument :org, type: :string, desc: DESC_ORG
    argument :key_path, type: :string, desc: DESC_PRIVATE_KEY

    # vcenter orchestrator
    class_option :vco_url, type: :string, desc: DESC_VCO_URL
    class_option :vco_user, type: :string, desc: DESC_VCO_USER
    class_option :vco_password, type: :string, desc: DESC_VCO_PASSWORD
    class_option :vco_password, type: :string, desc: DESC_VCO_WF_NAME

    def vco_workflow
      puts 'vco_workflow'
      VcoWorkflows::Workflow.new(options[:vco_wf_name] || VCO_WF_NAME,
                                 url: options[:vco_url] || VCO_URL,
                                 verify_ssl: false,
                                 username: options[:vco_user] || VCO_USER,
                                 password: options[:vco_password] || VCO_PASSWORD)
    end

    def set_private_key
      puts 'set_private_key'
    end

  end
end

