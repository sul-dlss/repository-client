# frozen_string_literal: true

module SdrClient
  # The command line interface
  module CLI
    HELP = <<~HELP
      DESCRIPTION:
        The SDR Command Line Interface is a tool to interact with the Stanford Digital Repository.

      SYNOPSIS:
        sdr [options] <command>

        To see help text for each command you can run:

        sdr [options] <command> help

      OPTIONS:
        --service-url (string)
        Override the command's default URL with the given URL.

        -h, --help
        Displays this screen


      COMMANDS:
        deposit
          Accession an object into the SDR

        register
          Create a draft object in SDR and retrieve a Druid identifier.

        login
          Will prompt for email & password and exchange it for an login token, which it saves in ~/.sdr/token

    HELP

    def self.start(command, options)
      case command
      when 'deposit'
        SdrClient::Deposit.run(accession: true, **options)
      when 'register'
        SdrClient::Deposit.run(accession: false, **options)
      when 'login'
        status = SdrClient::Login.run(options)
        puts status.failure if status.failure?
      else
        raise "Unknown command #{command}"
      end
    rescue SdrClient::Credentials::NoCredentialsError
      puts 'Log in first'
      exit(1)
    end

    def self.help
      puts HELP
      exit
    end
  end
end
