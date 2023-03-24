require 'net/scp'

class SCPSession
    def initialize(host, port, user, password, caller_ref)
        @host = host
        @port = port
        @user = user
        @password = password
        @caller = caller_ref
        @retry_count = 0
        @max_retries = 1
    end

    def ss
        Thread.current[:simplessh] ||= Net::SCP.start(@host, @user, password: @password, port: @port)
    end

    def upload!(local, remote)
        begin
            ss.upload! "#{local}", "#{remote}"
            # This shouldn't be run if we get an exception
            @retry_count = 0
        rescue Errno::ECONNRESET, Net::SSH::Disconnect => e
            raise e if @retry_count >= @max_retries
            @retry_count += 1
            @caller.log "Failed uploading and will try again."
            @caller.log "The reason was #{e}" unless @caller.quiet?
            close
            retry

        end
    end

    def mkdir!(dir)
        begin
            check_exists = ss.session.exec  "ls -ld #{dir}"
            ss.session.exec "mkdir #{dir}" if check_exists.exit_code
            # This shouldn't be run if we get an exception
            @retry_count = 0
        rescue Errno::ECONNRESET, Net::SSH::Disconnect => e
            raise e if @retry_count >= @max_retries
            @retry_count += 1
            @caller.log "Failed making directory and will try again."
            @caller.log "The reason was #{e}" unless @caller.quiet?
            close
            retry
        end
    end

    def remove!(remote)
        begin
            ss.session.exec  "rm #{remote}"
            # This shouldn't be run if we get an exception
            @retry_count = 0
        rescue Errno::ECONNRESET, Net::SSH::Disconnect => e
            raise e if @retry_count >= @max_retries
            @retry_count += 1
            @caller.log "Failed removing file and will try again."
            @caller.log "The reason was #{e}" unless @caller.quiet?
            close
            retry
        end
    end

    def rmdir!(dir)
        throw NotImplementedError
    end

    def ls!(dir)
        begin
            ss.session.exec  "ls #{dir}"
            # This shouldn't be run if we get an exception
            @retry_count = 0
        rescue Errno::ECONNRESET, Net::SSH::Disconnect => e
            raise e if @retry_count >= @max_retries
            @retry_count += 1
            @caller.log "Failed listing directory contents and will try again."
            @caller.log "The reason was #{e}" unless @caller.quiet?
            close
            retry
        end
    end

    def close
        ss.close
        Thread.current[:simplessh] = nil
    end
end
