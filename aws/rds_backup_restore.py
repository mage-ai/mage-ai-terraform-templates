import argparse
import boto3


def create_rds_snapshot(db_instance_identifier, snapshot_identifier):
    rds_client = boto3.client('rds')
    response = rds_client.create_db_snapshot(
        DBInstanceIdentifier=db_instance_identifier,
        DBSnapshotIdentifier=snapshot_identifier
    )
    return response['DBSnapshot']['DBSnapshotIdentifier']


def restore_rds_snapshot(snapshot_identifier, new_db_instance_identifier):
    rds_client = boto3.client('rds')
    response = rds_client.restore_db_instance_from_db_snapshot(
        DBInstanceIdentifier=new_db_instance_identifier,
        DBSnapshotIdentifier=snapshot_identifier
    )
    return response['DBInstance']['DBInstanceIdentifier']


def verify_snapshot(snapshot_identifier):
    rds_client = boto3.client('rds')
    response = rds_client.describe_db_snapshots(
        DBSnapshotIdentifier=snapshot_identifier
    )
    snapshots = response['DBSnapshots']
    if len(snapshots) == 0:
        return False
    snapshot_status = snapshots[0]['Status']
    return snapshot_status == 'available'


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='RDS Snapshot Backup and Restore')
    parser.add_argument('command', choices=[
                        'backup', 'restore', 'verify'], help='Command to execute: backup, restore, or verify')
    parser.add_argument('--db-instance', dest='db_instance',
                        help='DB instance identifier')
    parser.add_argument('--snapshot', dest='snapshot',
                        help='Snapshot identifier')
    parser.add_argument('--new-db-instance', dest='new_db_instance',
                        help='New DB instance identifier (for restore)')
    args = parser.parse_args()

    if args.command == 'backup':
        if not args.db_instance or not args.snapshot:
            parser.error(
                "For backup command, --db-instance and --snapshot are required.")
        snapshot_id = create_rds_snapshot(args.db_instance, args.snapshot)
        print(f"Snapshot created: {snapshot_id}")
    elif args.command == 'restore':
        if not args.snapshot or not args.new_db_instance:
            parser.error(
                "For restore command, --snapshot and --new-db-instance are required.")
        restored_db_id = restore_rds_snapshot(
            args.snapshot, args.new_db_instance)
        print(f"Restored DB instance: {restored_db_id}")
    elif args.command == 'verify':
        if not args.snapshot:
            parser.error("For verify command, --snapshot is required.")
        snapshot_verified = verify_snapshot(args.snapshot)
        if snapshot_verified:
            print("Snapshot is available.")
        else:
            print("Snapshot is not available.")


# python rds_backup_restore.py backup --db-instance dataeng-mage-prod-db --snapshot mage-db-snapshot-2023-07-06
# python rds_backup_restore.py verify --snapshot mage-db-snapshot-2023-07-06
# python rds_backup_restore.py restore --snapshot 2023-07-06-mage-db-snapshot --new-db-instance dataeng-mage-prod-db
