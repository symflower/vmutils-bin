ARG VM_VERSION

FROM victoriametrics/vmbackup:$VM_VERSION AS vmbackup

RUN apk add --no-cache curl bash jq

RUN mkdir /job
ADD backup-now.sh /job/backup-now.sh
ADD entry.sh /entry.sh

RUN chmod +x /job/backup-now.sh /entry.sh

ENTRYPOINT ["/entry.sh"]
