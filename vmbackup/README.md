# VMBackup - Cronjob Image

This is a docker container image to run `vmbackup` within a cronjob. It can be used as sidecar container to `vmstorage` for automated continuous backups. This one is heavily inspired by https://github.com/mysteriumnetwork/vmbackup.


## Environment variables

| Variable            | Default                                 | Description                                                                                           |
| ------------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| CRON_SCHEDULE       | "0 2 * * *"                             | The cronjob schedule on when the backup should run                                                    |
| SNAPSHOT_CREATE_URL | http://$(hostname):8482/snapshot/create | Substitutes the hostname for in cluster resolving                                                     |
| DST_URL             | fs:///vm-backup/$(hostname)/            | Store backups in at the filesystem with a hostname subdirectory to be aware of multiple storage nodes |
| STORAGE_PATH        | /vm-data                                | The absolute path to the mounted volume from `vmstorage`                                              |
| BACKOFF_TIME        | 10m                                     | Wait 10m if a backup did fail                                                                         |
| MAX_TRIES           | 5                                       | 5 * 10 minutes = about 50 minutes total of waiting, not counting running and failing.                 |


## Usage

Add a ReadWriteMany PVC to store your backups.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: vmbackup
spec:
  resources:
    requests:
      storage: 30Gi
  storageClassName: ceph-cephfs-sc
  accessModes:
    - ReadWriteMany # This one is important because all sidecars are writing at the same time to the volume.
```

Add the following parts to your `vmstorage` spec configuration to automatically deploy the `vmbackup` image as sidecar container.

```yaml
apiVersion: operator.victoriametrics.com/v1beta1
kind: VMCluster
metadata:
  name: example-vmcluster
spec:
  vmstorage:
    volumes:
      - name: vmbackup
        persistentVolumeClaim:
          claimName: vmbackup
    containers:
      - name: vmbackup
        image: ghcr.io/symflower/vmbackup:v1.93.4 # or :latest
        volumeMounts:
          - mountPath: /vm-data # This is the mount path for STORAGE_PATH.
            name: vmstorage-db # This is the default storage volume of vmstorage.
            readonly: true
          - mountPath: /vm-backup # This is the mount path for DST_URL.
            name: vmbackup
```
