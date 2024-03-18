{
  /**
   * Creates a [CloudWatch target](https://grafana.com/docs/grafana/latest/datasources/cloudwatch/)
   *
   * @name cloudwatch.target
   *
   * @return Panel target
   */

  target(
    id                = null,
    alias             = null,
    datasource        = null,
    dimensions        = {},
    expression        = '',
    matchExact        = false,
    metricEditorMode  = $.editorModes.Builder,
    metricName        = null,
    metricQueryType   = $.queryTypes.Search,
    namespace,
    period            = 'auto',
    queryMode         = $.queryModes.Metrics,
    logGroups         = null,
    region            = 'default',
    sql               = null,
    sqlExpression     = null,
    statistic         = $.statistics.Average,
    hide              = null,
    refId             = null,
  ):: {
    [if id            != null then 'id']: id,
    [if hide          != null then 'hide']: hide,
    [if alias         != null then 'alias']: alias,
    [if datasource    != null then 'datasource']: datasource,
    dimensions:       dimensions,
    expression:       expression,
    matchExact:       matchExact,
    metricEditorMode: metricEditorMode,
    metricName:       metricName,
    metricQueryType:  metricQueryType,
    namespace:        namespace,
    period:           period,
    queryMode:        queryMode,
    logGroups:        logGroups,
    region:           region,
    [if sql           != null then 'sql']: sql,
    [if sqlExpression != null then 'sqlExpression']: sqlExpression,
    statistic:        statistic,
    [if refId         != null then 'refId']: refId,
  },

  editorModes:: {
    Builder:  0,
    Code:     1,
  },

  queryTypes:: {
    Search:  0,
    Query:   1,
  },

  queryModes:: {
    Metrics:      'Metrics',
    Logs:         'Logs',
    Annotations:  'Annotations',
  },

  statistics:: {
    Average:: 'Average',
    Maximum:: 'Maximum',
    Minimum:: 'Minimum',
    Sum::     'Sum',
  },

  namespace:: {
    ACMPrivateCA::              'AWS/ACMPrivateCA',
    AmazonMQ::                  'AWS/AmazonMQ',
    AmplifyHosting::            'AWS/AmplifyHosting',
    ApiGateway::                'AWS/ApiGateway',
    AppRunner::                 'AWS/AppRunner',
    AppStream::                 'AWS/AppStream',
    AppSync::                   'AWS/AppSync',
    ApplicationELB::            'AWS/ApplicationELB',
    Athena::                    'AWS/Athena',
    AutoScaling::               'AWS/AutoScaling',
    Backup::                    'AWS/Backup',
    Billing::                   'AWS/Billing',
    Cassandra::                 'AWS/Cassandra',
    CertificateManager::        'AWS/CertificateManager',
    Chatbot::                   'AWS/Chatbot',
    ClientVPN::                 'AWS/ClientVPN',
    CloudFront::                'AWS/CloudFront',
    CloudHSM::                  'AWS/CloudHSM',
    CloudSearch::               'AWS/CloudSearch',
    CodeBuild::                 'AWS/CodeBuild',
    CodeGuruProfiler::          'AWS/CodeGuruProfiler',
    Cognito::                   'AWS/Cognito',
    Connect::                   'AWS/Connect',
    DAX::                       'AWS/DAX',
    DDoSProtection::            'AWS/DDoSProtection',
    DMS::                       'AWS/DMS',
    DX::                        'AWS/DX',
    DataLifecycleManager::      'AWS/DataLifecycleManager',
    DataSync::                  'AWS/DataSync',
    DocDB::                     'AWS/DocDB',
    DynamoDB::                  'AWS/DynamoDB',
    EBS::                       'AWS/EBS',
    EC2::                       'AWS/EC2',
    EC2_API::                   'AWS/EC2/API',
    EC2_CapacityReservations::  'AWS/EC2CapacityReservations',
    EC2_Spot::                  'AWS/EC2Spot',
    ECS::                       'AWS/ECS',
    EFS::                       'AWS/EFS',
    ELB::                       'AWS/ELB',
    ES::                        'AWS/ES',
    ElastiCache::               'AWS/ElastiCache',
    ElasticBeanstalk::          'AWS/ElasticBeanstalk',
    ElasticGPUs::               'AWS/ElasticGPUs',
    ElasticInference::          'AWS/ElasticInference',
    ElasticMapReduce::          'AWS/ElasticMapReduce',
    ElasticTranscoder::         'AWS/ElasticTranscoder',
    Events::                    'AWS/Events',
    FSx::                       'AWS/FSx',
    Firehose::                  'AWS/Firehose',
    GameLift::                  'AWS/GameLift',
    GatewayELB::                'AWS/GatewayELB',
    GlobalAccelerator::         'AWS/GlobalAccelerator',
    Glue::                      'AWS/Glue',
    GroundStation::             'AWS/GroundStation',
    IVS::                       'AWS/IVS',
    Inspector::                 'AWS/Inspector',
    IoT::                       'AWS/IoT',
    IoTAnalytics::              'AWS/IoTAnalytics',
    KMS::                       'AWS/KMS',
    Kafka::                     'AWS/Kafka',
    Kinesis::                   'AWS/Kinesis',
    KinesisAnalytics::          'AWS/KinesisAnalytics',
    KinesisVideo::              'AWS/KinesisVideo',
    Lambda::                    'AWS/Lambda',
    Lex::                       'AWS/Lex',
    Logs::                      'AWS/Logs',
    LookoutMetrics::            'AWS/LookoutMetrics',
    ML::                        'AWS/ML',
    MediaConnect::              'AWS/MediaConnect',
    MediaConvert::              'AWS/MediaConvert',
    MediaPackage::              'AWS/MediaPackage',
    MediaStore::                'AWS/MediaStore',
    MediaTailor::               'AWS/MediaTailor',
    MemoryDB::                  'AWS/MemoryDB',
    NATGateway::                'AWS/NATGateway',
    Neptune::                   'AWS/Neptune',
    NetworkELB::                'AWS/NetworkELB',
    NetworkFirewall::           'AWS/NetworkFirewall',
    OpsWorks::                  'AWS/OpsWorks',
    Polly::                     'AWS/Polly',
    PrivateLinkEndpoints::      'AWS/PrivateLinkEndpoints',
    PrivateLinkServices::       'AWS/PrivateLinkServices',
    Prometheus::                'AWS/Prometheus',
    RDS::                       'AWS/RDS',
    Redshift::                  'AWS/Redshift',
    Rekognition::               'AWS/Rekognition',
    Robomaker::                 'AWS/Robomaker',
    Route53::                   'AWS/Route53',
    Route53Resolver::           'AWS/Route53Resolver',
    S3::                        'AWS/S3',
    SDKMetrics::                'AWS/SDKMetrics',
    SES::                       'AWS/SES',
    SNS::                       'AWS/SNS',
    SQS::                       'AWS/SQS',
    SWF::                       'AWS/SWF',
    SageMaker::                 'AWS/SageMaker',
    ServiceCatalog::            'AWS/ServiceCatalog',
    States::                    'AWS/States',
    StorageGateway::            'AWS/StorageGateway',
    Textract::                  'AWS/Textract',
    ThingsGraph::               'AWS/ThingsGraph',
    Timestream::                'AWS/Timestream',
    Transfer::                  'AWS/Transfer',
    TransitGateway::            'AWS/TransitGateway',
    Translate::                 'AWS/Translate',
    TrustedAdvisor::            'AWS/TrustedAdvisor',
    Usage::                     'AWS/Usage',
    VPN::                       'AWS/VPN',
    WAF::                       'AWS/WAF',
    WAFV2::                     'AWS/WAFV2',
    WorkSpaces::                'AWS/WorkSpaces',
    CloudWatchSynthetics::      'CloudWatchSynthetics',
    ContainerInsights::         'ContainerInsights',
    ECS_ContainerInsights::     'ECS/ContainerInsights',
  },


  metrics:: {
    amazonmq:: {
      AckRate::                                       'AckRate',                                          // The rate at which messages are being acknowledged by consumers.
      BurstBalance::                                  'BurstBalance',                                     // The percentage of burst credits remaining on the Amazon EBS volume used to persist message data for throughput-optimized brokers.
      ChannelCount::                                  'ChannelCount',                                     // The total number of channels established on the broker.
      ConfirmRate::                                   'ConfirmRate',                                      // The rate (msg/s) at which the RabbitMQ server is confirming published messages.
      ConnectionCount::                               'ConnectionCount',                                  // The total number of connections established on the broker
      ConsumerCount::                                 'ConsumerCount',                                    // The total number of consumers connected to the broker.
      CpuCreditBalance::                              'CpuCreditBalance',                                 // The number of earned CPU credits that an instance has accrued since it was launched or started (only for mq.t2.micro).
      CpuUtilization::                                'CpuUtilization',                                   // The percentage of allocated Amazon EC2 compute units that the broker currently uses.
      CurrentConnectionsCount::                       'CurrentConnectionsCount',                          // The current number of active connections on the current broker.
      DequeueCount::                                  'DequeueCount',                                     // The number of messages acknowledged by consumers, per minute.
      DispatchCount::                                 'DispatchCount',                                    // The number of messages sent to consumers, per minute.
      EnqueueCount::                                  'EnqueueCount',                                     // The number of messages sent to the destination, per minute.
      EnqueueTime::                                   'EnqueueTime',                                      // The end-to-end latency from when a message arrives at a broker until it is delivered to a consumer.
      EstablishedConnectionsCount::                   'EstablishedConnectionsCount',                      // The total number of connections, active and inactive, that have been established on the broker.
      ExchangeCount::                                 'ExchangeCount',                                    // The total number of exchanges configured on the broker
      ExpiredCount::                                  'ExpiredCount',                                     // The number of messages that couldn't be delivered because they expired, per minute.
      HeapUsage::                                     'HeapUsage',                                        // The percentage of the ActiveMQ JVM memory limit that the broker currently uses.
      InFlightCount::                                 'InFlightCount',                                    // The number of messages sent to consumers that have not been acknowledged, per minute.
      InactiveDurableTopicSubscribersCount::          'InactiveDurableTopicSubscribersCount',             // The number of inactive durable topic subscribers, up to a maximum of 2000.
      JobSchedulerStorePercentUsage::                 'JobSchedulerStorePercentUsage',                    // The percentage of disk space used by the job scheduler
      JournalFilesForFastRecovery::                   'JournalFilesForFastRecovery',                      // The number of journal files that will be replayed after a clean shutdown.
      JournalFilesForFullRecovery::                   'JournalFilesForFullRecovery',                      // The number of journal files that will be replayed after an unclean shutdown.
      MemoryUsage::                                   'MemoryUsage',                                      // The percentage of the memory limit that the destination currently uses.
      MessageCount::                                  'MessageCount',                                     // The total number of messages in the queues.
      MessageReadyCount::                             'MessageReadyCount',                                // The total number of ready messages in the queues.
      MessageUnacknowledgedCount::                    'MessageUnacknowledgedCount',                       // The number of messages for which the server is awaiting acknowledgement.
      NetworkIn::                                     'NetworkIn',                                        // The volume of incoming traffic for the broker.
      NetworkOut::                                    'NetworkOut',                                       // The volume of outgoing traffic for the broker.
      OpenTransactionCount::                          'OpenTransactionCount',                             // The total number of transactions in progress.
      ProducerCount::                                 'ProducerCount',                                    // The number of producers for the destination.
      PublishRate::                                   'PublishRate',                                      // The rate at which messages are published to the broker.
      QueueCount::                                    'QueueCount',                                       // The total number of queues configured on the broker.
      QueueSize::                                     'QueueSize',                                        // The number of messages in the queue.
      RabbitMQDiskFree::                              'RabbitMQDiskFree',                                 // The total volume of free disk space available in a RabbitMQ broker.
      RabbitMQDiskFreeLimit::                         'RabbitMQDiskFreeLimit',                            // The disk limit for a RabbitMQ broker.
      RabbitMQFdUsed::                                'RabbitMQFdUsed',                                   // Number of file descriptors used.
      RabbitMQMemLimit::                              'RabbitMQMemLimit',                                 // The RAM limit for a RabbitMQ node
      RabbitMQMemUsed::                               'RabbitMQMemUsed',                                  // The volume of RAM used by a RabbitMQ node
      ReceiveCount::                                  'ReceiveCount',                                     // The number of messages that have been received from the remote broker for a duplex network connector.
      StorePercentUsage::                             'StorePercentUsage',                                // The percent used by the storage limit. If this reaches 100, the broker will refuse messages.
      SystemCpuUtilization::                          'SystemCpuUtilization',                             // The percentage of allocated Amazon EC2 compute units that the broker currently uses.
      TempPercentUsage::                              'TempPercentUsage',                                 // The percentage of available temporary storage used by non-persistent messages.
      TotalConsumerCount::                            'TotalConsumerCount',                               // The number of message consumers subscribed to destinations on the current broker.
      TotalDequeueCount::                             'TotalDequeueCount',                                // The total number of messages that have been consumed by clients.
      TotalEnqueueCount::                             'TotalEnqueueCount',                                // The total number of messages that have been sent to the broker.
      TotalMessageCount::                             'TotalMessageCount',                                // The number of messages stored on the broker.
      TotalProducerCount::                            'TotalProducerCount',                               // The number of message producers active on destinations on the current broker.
      VolumeReadOps::                                 'VolumeReadOps',                                    // The number of read operations performed on the Amazon EBS volume.
      VolumeWriteOps::                                'VolumeWriteOps',                                   // The number of write operations performed on the Amazon EBS volume.
    },

    application_elb:: {
      ActiveConnectionCount::                         'ActiveConnectionCount',                            // The total number of concurrent TCP connections active from clients to the load balancer and from the load balancer to targets.
      ClientTLSNegotiationErrorCount::                'ClientTLSNegotiationErrorCount',                   // The number of TLS connections initiated by the client that did not establish a session with the load balancer due to a TLS error.
      ConsumedLCUs::                                  'ConsumedLCUs',                                     // The number of load balancer capacity units (LCU) used by the load balancer.
      DroppedInvalidHeaderRequestCount::              'DroppedInvalidHeaderRequestCount',                 // The number of requests where the load balancer removed HTTP headers with header fields that are not valid before routing the request.
      ELBAuthError::                                  'ELBAuthError',                                     // The number of user authentications that could not be completed because an authenticate action was misconfigured, the load balancer couldn't establish a connection with the IdP, or the load balancer couldn't complete the authentication flow due to an internal error.
      ELBAuthFailure::                                'ELBAuthFailure',                                   // The number of user authentications that could not be completed because the IdP denied access to the user or an authorization code was used more than once.
      ELBAuthLatency::                                'ELBAuthLatency',                                   // The time elapsed, in milliseconds, to query the IdP for the ID token and user info.
      ELBAuthRefreshTokenSuccess::                    'ELBAuthRefreshTokenSuccess',                       // The number of times the load balancer successfully refreshed user claims using a refresh token provided by the IdP.
      ELBAuthSuccess::                                'ELBAuthSuccess',                                   // The number of authenticate actions that were successful.
      ELBAuthUserClaimsSizeExceeded::                 'ELBAuthUserClaimsSizeExceeded',                    // The number of times that a configured IdP returned user claims that exceeded 11K bytes in size.
      ForwardedInvalidHeaderRequestCount::            'ForwardedInvalidHeaderRequestCount',               // The number of requests routed by the load balancer that had HTTP headers with header fields that are not valid.
      GrpcRequestCount::                              'GrpcRequestCount',                                 // The number of gRPC requests processed over IPv4 and IPv6.
      HTTPCode_ELB_3XX_Count::                        'HTTPCode_ELB_3XX_Count',                           // The number of HTTP 3XX redirection codes that originate from the load balancer.
      HTTPCode_ELB_4XX_Count::                        'HTTPCode_ELB_4XX_Count',                           // The number of HTTP 4XX client error codes that originate from the load balancer.
      HTTPCode_ELB_500_Count::                        'HTTPCode_ELB_500_Count',                           // The number of HTTP 500 error codes that originate from the load balancer.
      HTTPCode_ELB_502_Count::                        'HTTPCode_ELB_502_Count',                           // The number of HTTP 502 error codes that originate from the load balancer.
      HTTPCode_ELB_503_Count::                        'HTTPCode_ELB_503_Count',                           // The number of HTTP 503 error codes that originate from the load balancer.
      HTTPCode_ELB_504_Count::                        'HTTPCode_ELB_504_Count',                           // The number of HTTP 504 error codes that originate from the load balancer.
      HTTPCode_ELB_5XX_Count::                        'HTTPCode_ELB_5XX_Count',                           // The number of HTTP 5XX server error codes that originate from the load balancer.
      HTTPCode_Target_2XX_Count::                     'HTTPCode_Target_2XX_Count',                        // The number of HTTP 2XX response codes generated by the targets.
      HTTPCode_Target_3XX_Count::                     'HTTPCode_Target_3XX_Count',                        // The number of HTTP 3XX response codes generated by the targets.
      HTTPCode_Target_4XX_Count::                     'HTTPCode_Target_4XX_Count',                        // The number of HTTP 4XX response codes generated by the targets.
      HTTPCode_Target_5XX_Count::                     'HTTPCode_Target_5XX_Count',                        // The number of HTTP 5XX response codes generated by the targets.
      HTTP_Fixed_Response_Count::                     'HTTP_Fixed_Response_Count',                        // The number of fixed-response actions that were successful.
      HTTP_Redirect_Count::                           'HTTP_Redirect_Count',                              // The number of redirect actions that were successful.
      HTTP_Redirect_Url_Limit_Exceeded_Count::        'HTTP_Redirect_Url_Limit_Exceeded_Count',           // The number of redirect actions that couldn't be completed because the URL in the response location header is larger than 8K.
      HealthyHostCount::                              'HealthyHostCount',                                 // The number of targets that are considered healthy.
      IPv6ProcessedBytes::                            'IPv6ProcessedBytes',                               // The total number of bytes processed by the load balancer over IPv6.
      IPv6RequestCount::                              'IPv6RequestCount',                                 // The number of IPv6 requests received by the load balancer.
      LambdaInternalError::                           'LambdaInternalError',                              // The number of requests to a Lambda function that failed because of an issue internal to the load balancer or AWS Lambda.
      LambdaTargetProcessedBytes::                    'LambdaTargetProcessedBytes',                       // The total number of bytes processed by the load balancer for requests to and responses from a Lambda function.
      LambdaUserError::                               'LambdaUserError',                                  // The number of requests to a Lambda function that failed because of an issue with the Lambda function.
      NewConnectionCount::                            'NewConnectionCount',                               // The total number of new TCP connections established from clients to the load balancer and from the load balancer to targets.
      NonCompliantRequestCount::                      'DesyncMitigationMode_NonCompliant_Request_Count',  // The number of requests that do not comply with RFC 7230.
      NonStickyRequestCount::                         'NonStickyRequestCount',                            // The number of requests where the load balancer chose a new target because it couldn't use an existing sticky session.
      ProcessedBytes::                                'ProcessedBytes',                                   // The total number of bytes processed by the load balancer over IPv4 and IPv6 (HTTP header and HTTP payload).
      RejectedConnectionCount::                       'RejectedConnectionCount',                          // The number of connections that were rejected because the load balancer had reached its maximum number of connections.
      RequestCount::                                  'RequestCount',                                     // The number of requests processed over IPv4 and IPv6.
      RequestCountPerTarget::                         'RequestCountPerTarget',                            // The average number of requests received by each target in a target group.
      RuleEvaluations::                               'RuleEvaluations',                                  // The number of rules processed by the load balancer given a request rate averaged over an hour.
      TargetConnectionErrorCount::                    'TargetConnectionErrorCount',                       // The number of connections that were not successfully established between the load balancer and target
      TargetResponseTime::                            'TargetResponseTime',                               // The time elapsed, in seconds, after the request leaves the load balancer until a response from the target is received.
      TargetTLSNegotiationErrorCount::                'TargetTLSNegotiationErrorCount',                   // The number of TLS connections initiated by the load balancer that did not establish a session with the target.
      UnHealthyHostCount::                            'UnHealthyHostCount',                               // The number of targets that are considered unhealthy.
    },

    autoscaling:: {
      GroupDesiredCapacity::                          'GroupDesiredCapacity',                             // The number of instances that the Auto Scaling group attempts to maintain.
      GroupInServiceInstances::                       'GroupInServiceInstances',                          // The number of instances that are running as part of the Auto Scaling group.
      GroupMaxSize::                                  'GroupMaxSize',                                     // The maximum size of the Auto Scaling group.
      GroupMinSize::                                  'GroupMinSize',                                     // The minimum size of the Auto Scaling group.
      GroupPendingInstances::                         'GroupPendingInstances',                            // The number of instances that are pending.
      GroupStandbyInstances::                         'GroupStandbyInstances',                            // The number of instances that are in a Standby state.
      GroupTerminatingInstances::                     'GroupTerminatingInstances',                        // The number of instances that are in the process of terminating.
      GroupTotalInstances::                           'GroupTotalInstances',                              // The total number of instances in the Auto Scaling group.
    },

    docdb:: {
      BackupRetentionPeriodStorageUsed::              'BackupRetentionPeriodStorageUsed',                 // The total amount of backup storage in GiB used to support the point-in-time restore feature within the Amazon DocumentDB's retention window.
      BufferCacheHitRatio::                           'BufferCacheHitRatio',                              // The percentage of requests that are served by the buffer cache.
      CPUUtilization::                                'CPUUtilization',                                   // The percentage of CPU used by an instance.
      ChangeStreamLogSize::                           'ChangeStreamLogSize',                              // The amount of storage used by the cluster to store the change stream log in megabytes.
      DBClusterReplicaLagMaximum::                    'DBClusterReplicaLagMaximum',                       // The maximum amount of lag, in milliseconds, between the primary instance and each Amazon DocumentDB instance in the cluster.
      DBClusterReplicaLagMinimum::                    'DBClusterReplicaLagMinimum',                       // The minimum amount of lag, in milliseconds, between the primary instance and each replica instance in the cluster.
      DBInstanceReplicaLag::                          'DBInstanceReplicaLag',                             // The amount of lag in milliseconds when replicating updates from the primary instance to a replica.
      DatabaseConnections::                           'DatabaseConnections',                              // The number of connections open on an instance taken at a one-minute frequency.
      DiskQueueDepth::                                'DiskQueueDepth',                                   // The number of concurrent write requests to the distributed storage volume.
      EngineUptime::                                  'EngineUptime',                                     // The amount of time, in seconds, that the instance has been running.
      FreeLocalStorage::                              'FreeLocalStorage',                                 // The amount of storage available to each instance for temporary tables and logs.
      FreeableMemory::                                'FreeableMemory',                                   // The amount of available random access memory, in bytes.
      LowMemNumOperationsThrottled::                  'LowMemNumOperationsThrottled',                     // The number of read and write operations that have been throttled due to low memory.
      NetworkReceiveThroughput::                      'NetworkReceiveThroughput',                         // The amount of network throughput, in bytes per second, received from clients by each instance in the cluster.
      NetworkThroughput::                             'NetworkThroughput',                                // The amount of network throughput, in bytes per second, both received from and transmitted to clients by each instance in the cluster
      NetworkTransmitThroughput::                     'NetworkTransmitThroughput',                        // The amount of network throughput, in bytes per second, sent to clients by each instance in the cluster.
      ReadIOPS::                                      'ReadIOPS',                                         // The average number of disk read I/O operations per second. Amazon DocumentDB reports read and write IOPS separately, and on one-minute intervals.
      ReadLatency::                                   'ReadLatency',                                      // The average amount of time taken per disk I/O operation.
      ReadThroughput::                                'ReadThroughput',                                   // The average number of bytes read from disk per second.
      SnapshotStorageUsed::                           'SnapshotStorageUsed',                              // The total amount of backup storage in GiB consumed by all snapshots for the cluster outside its backup retention window.
      SwapUsage::                                     'SwapUsage',                                        // The amount of swap space used on the instance.
      TotalBackupStorageBilled::                      'TotalBackupStorageBilled',                         // The total amount of backup storage in GiB for which you are billed for the cluster.
      VolumeBytesUsed::                               'VolumeBytesUsed',                                  // The amount of storage used by your cluster in bytes.
      VolumeReadIOPs::                                'VolumeReadIOPs',                                   // The average number of billed read I/O operations from a cluster volume, reported at 5-minute intervals.
      VolumeWriteIOPs::                               'VolumeWriteIOPs',                                  // The average number of billed write I/O operations from a cluster volume, reported at 5-minute intervals.
      WriteIOPS::                                     'WriteIOPS',                                        // The average number of disk write I/O operations per second. When used on a cluster level.
      WriteLatency::                                  'WriteLatency',                                     // The average amount of time, in milliseconds, taken per disk I/O operation.
      WriteThroughput::                               'WriteThroughput',                                  // The average number of bytes written to disk per second.
    },

    ecs:: {
      CPUReservation::                                'CPUReservation',                                   // The percentage of CPU units that are reserved by running tasks in the cluster.
      CPUUtilization::                                'CPUUtilization',                                   // The percentage of CPU units that are used in the cluster or service.
      GPUReservation::                                'GPUReservation',                                   // The percentage of total available GPUs that are reserved by running tasks in the cluster.
      MemoryReservation::                             'MemoryReservation',                                // The percentage of memory that is reserved by running tasks in the cluster.
      MemoryUtilization::                             'MemoryUtilization',                                // The percentage of memory that is used in the cluster or service.
    },

    efs:: {
      BurstCreditBalance::                            'BurstCreditBalance',                               // The number of burst credits that a file system has.
      ClientConnections::                             'ClientConnections',                                // The number of client connections to a file system.
      DataReadIOBytes::                               'DataReadIOBytes',                                  // The number of bytes for each file system read operation.
      DataWriteIOBytes::                              'DataWriteIOBytes',                                 // The number of bytes for each file system write operation.
      MetadataIOBytes::                               'MetadataIOBytes',                                  // The number of bytes for each metadata operation.
      PercentIOLimit::                                'PercentIOLimit',                                   // Shows how close a file system is to reaching the I/O limit of the General Purpose performance mode.
      PermittedThroughput::                           'PermittedThroughput',                              // The maximum amount of throughput that a file system can drive.
      TotalIOBytes::                                  'TotalIOBytes',                                     // The actual number of bytes for each file system operation, including data read, data write, and metadata operations.
      StorageBytes::                                  'StorageBytes',                                     // The size of the file system in bytes, including the amount of data stored in the EFS Standard and EFS Standard–Infrequent Access (EFS Standard-IA) storage classes.
      MeteredIOBytes::                                'MeteredIOBytes',                                   // The number of metered bytes for each file system operation, including data read, data write, and metadata operations, with read operations metered at one-third the rate of other operations.

    },

    elb:: {
      BackendConnectionErrors::                       'BackendConnectionErrors',                          // The number of connections that were not successfully established between the load balancer and the registered instances
      EstimatedALBActiveConnectionCount::             'EstimatedALBActiveConnectionCount',                // The estimated number of concurrent TCP connections active from clients to the load balancer and from the load balancer to targets.
      EstimatedALBConsumedLCUs::                      'EstimatedALBConsumedLCUs',                         // The estimated number of load balancer capacity units (LCU) used by an Application Load Balancer.
      EstimatedALBNewConnectionCount::                'EstimatedALBNewConnectionCount',                   // The estimated number of new TCP connections established from clients to the load balancer and from the load balancer to targets.
      EstimatedProcessedBytes::                       'EstimatedProcessedBytes',                          // The estimated number of bytes processed by an Application Load Balancer.
      HTTPCode_Backend_2XX::                          'HTTPCode_Backend_2XX',                             // The number of 2XX HTTP response codes generated by registered instances.
      HTTPCode_Backend_3XX::                          'HTTPCode_Backend_3XX',                             // The number of 3XX HTTP response codes generated by registered instances.
      HTTPCode_Backend_4XX::                          'HTTPCode_Backend_4XX',                             // The number of 4XX HTTP response codes generated by registered instances.
      HTTPCode_Backend_5XX::                          'HTTPCode_Backend_5XX',                             // The number of 5XX HTTP response codes generated by registered instances.
      HTTPCode_ELB_4XX::                              'HTTPCode_ELB_4XX',                                 // The number of HTTP 4XX client error codes generated by the load balancer.
      HTTPCode_ELB_5XX::                              'HTTPCode_ELB_5XX',                                 // The number of HTTP 5XX server error codes generated by the load balancer.
      HealthyHostCount::                              'HealthyHostCount',                                 // The number of healthy instances registered with your load balancer.
      Latency::                                       'Latency',                                          // The total time elapsed, in seconds, from the time the load balancer sent the request to a registered instance until the instance started to send the response headers.
      RequestCount::                                  'RequestCount',                                     // The number of requests completed or connections made during the specified interval (1 or 5 minutes).
      SpilloverCount::                                'SpilloverCount',                                   // The total number of requests that were rejected because the surge queue is full.
      SurgeQueueLength::                              'SurgeQueueLength',                                 // The total number of requests (HTTP listener) or connections (TCP listener) that are pending routing to a healthy instance.
      UnHealthyHostCount::                            'UnHealthyHostCount',                               // The number of unhealthy instances registered with your load balancer.
    },

    elasticache:: {
		  CPUCreditBalance::                              'CPUCreditBalance',                                 // Host - The number of earned CPU credits that an instance has accrued since it was launched or started. For T2 Standard, the CPUCreditBalance also includes the number of launch credits that have been accrued.
		  CPUCreditUsage::                                'CPUCreditUsage',                                   // Host - The number of CPU credits spent by the instance for CPU utilization
		  CPUUtilization::                                'CPUUtilization',                                   // Host - The percentage of CPU utilization for the entire host.
		  FreeableMemory::                                'FreeableMemory',                                   // Host - The amount of free memory available on the host
		  NetworkBandwidthInAllowanceExceeded::           'NetworkBandwidthInAllowanceExceeded',              // Host - The number of packets queued or dropped because the inbound aggregate bandwidth exceeded the maximum for the instance.
		  NetworkBandwidthOutAllowanceExceeded::          'NetworkBandwidthOutAllowanceExceeded',             // Host - The number of packets queued or dropped because the outbound aggregate bandwidth exceeded the maximum for the instance.
		  NetworkBytesIn::                                'NetworkBytesIn',                                   // Host - The number of bytes the host has read from the network.
		  NetworkBytesOut::                               'NetworkBytesOut',                                  // Host - The number of bytes sent out on all network interfaces by the instance.
		  NetworkConntrackAllowanceExceeded::             'NetworkConntrackAllowanceExceeded',                // Host - The number of packets dropped because connection tracking exceeded the maximum for the instance and new connections could not be established.
		  NetworkLinkLocalAllowanceExceeded::             'NetworkLinkLocalAllowanceExceeded',                // Host - The number of packets dropped because the PPS of the traffic to local proxy services exceeded the maximum for the network interface.
		  NetworkPacketsIn::                              'NetworkPacketsIn',                                 // Host - The number of packets received on all network interfaces by the instance.
		  NetworkPacketsOut::                             'NetworkPacketsOut',                                // Host - The number of packets sent out on all network interfaces by the instance
		  NetworkPacketsPerSecondAllowanceExceeded::      'NetworkPacketsPerSecondAllowanceExceeded',         // Host - The number of packets queued or dropped because the bidirectional packets per second exceeded the maximum for the instance.
		  SwapUsage::                                     'SwapUsage',                                        // Host - The amount of swap used on the host

		  BytesReadIntoMemcached::                        'BytesReadIntoMemcached',                           // Memcached - The number of bytes that have been read from the network by the cache node.
		  BytesUsedForCacheItems::                        'BytesUsedForCacheItems',                           // Memcached - The number of bytes used to store cache items.
		  BytesUsedForHash::                              'BytesUsedForHash',                                 // Memcached - The number of bytes currently used by hash tables.
		  BytesWrittenOutFromMemcached::                  'BytesWrittenOutFromMemcached',                     // Memcached - The number of bytes that have been written to the network by the cache node.
		  CasBadval::                                     'CasBadval',                                        // Memcached - The number of CAS (check and set) requests the cache has received where the Cas value did not match the Cas value stored.
		  CasHits::                                       'CasHits',                                          // Memcached - The number of CAS requests the cache has received where the requested key was found and the Cas value matched.
		  CasMisses::                                     'CasMisses',                                        // Memcached - The number of CAS requests the cache has received where the key requested was not found.
		  CmdConfigGet::                                  'CmdConfigGet',                                     // Memcached - The cumulative number of config get requests.
		  CmdConfigSet::                                  'CmdConfigSet',                                     // Memcached - The cumulative number of config set requests.
		  CmdFlush::                                      'CmdFlush',                                         // Memcached - The number of flush commands the cache has received.
		  CmdGet::                                        'CmdGet',                                           // Memcached - The number of get commands the cache has received.
		  CmdSet::                                        'CmdSet',                                           // Memcached - The number of set commands the cache has received.
		  CmdTouch::                                      'CmdTouch',                                         // Memcached - The cumulative number of touch requests.
		  CurrConfig::                                    'CurrConfig',                                       // Memcached - The current number of configurations stored.
		  DecrHits::                                      'DecrHits',                                         // Memcached - The number of decrement requests the cache has received where the requested key was found.
		  DecrMisses::                                    'DecrMisses',                                       // Memcached - The number of decrement requests the cache has received where the requested key was not found.
		  DeleteHits::                                    'DeleteHits',                                       // Memcached - The number of delete requests the cache has received where the requested key was found.
		  DeleteMisses::                                  'DeleteMisses',                                     // Memcached - The number of delete requests the cache has received where the requested key was not found.
		  EvictedUnfetched::                              'EvictedUnfetched',                                 // Memcached - The number of valid items evicted from the least recently used cache (LRU) which were never touched after being set.
		  GetHits::                                       'GetHits',                                          // Memcached - The number of get requests the cache has received where the key requested was found.
		  GetMisses::                                     'GetMisses',                                        // Memcached - The number of get requests the cache has received where the key requested was not found.
		  IncrHits::                                      'IncrHits',                                         // Memcached - The number of increment requests the cache has received where the key requested was found
		  IncrMisses::                                    'IncrMisses',                                       // Memcached - The number of increment requests the cache has received where the key requested was not found
		  NewItems::                                      'NewItems',                                         // Memcached - The number of new items the cache has stored.
		  SlabsMoved::                                    'SlabsMoved',                                       // Memcached - The total number of slab pages that have been moved.
		  TouchHits::                                     'TouchHits',                                        // Memcached - The number of keys that have been touched and were given a new expiration time.
		  TouchMisses::                                   'TouchMisses',                                      // Memcached - The number of items that have been touched, but were not found.
		  UnusedMemory::                                  'UnusedMemory',                                     // Memcached - The amount of memory not used by data.
      ExpiredUnfetched::                              'ExpiredUnfetched',                                 // Memcached - The number of expired items reclaimed from the LRU which were never touched after being set.

		  AuthenticationFailures::                        'AuthenticationFailures',                           // Redis - The total number of failed attempts to authenticate to Redis using the AUTH command.
		  BytesReadFromDisk::                             'BytesReadFromDisk',                                // Redis - The total number of bytes read from disk per minute.
		  BytesUsedForCache::                             'BytesUsedForCache',                                // Redis - The total number of bytes allocated by Redis for all purposes, including the dataset, buffers, and so on.
		  BytesWrittenToDisk::                            'BytesWrittenToDisk',                               // Redis - The total number of bytes written to disk per minute.
		  CacheHitRate::                                  'CacheHitRate',                                     // Redis - Indicates the usage efficiency of the Redis instance.
		  CacheHits::                                     'CacheHits',                                        // Redis - The number of successful read-only key lookups in the main dictionary.
		  CacheMisses::                                   'CacheMisses',                                      // Redis - The number of unsuccessful read-only key lookups in the main dictionary.
		  CommandAuthorizationFailures::                  'CommandAuthorizationFailures',                     // Redis - The total number of failed attempts by users to run commands they don’t have permission to call.
		  CurrConnections::                               'CurrConnections',                                  // Redis - The number of client connections, excluding connections from read replicas.
		  CurrItems::                                     'CurrItems',                                        // Redis - The number of items in the cache.
		  CurrVolatileItems::                             'CurrVolatileItems',                                // Redis - Total number of keys in all databases that have a ttl set.
		  DB0AverageTTL::                                 'DB0AverageTTL',                                    // Redis - Exposes avg_ttl of DBO from the keyspace statistic of Redis INFO command.
		  DatabaseMemoryUsageCountedForEvictPercentage::  'DatabaseMemoryUsageCountedForEvictPercentage',     // Redis - Percentage of the memory for the cluster that is in use, excluding memory used for overhead and COB.
		  DatabaseMemoryUsagePercentage::                 'DatabaseMemoryUsagePercentage',                    // Redis - Percentage of the memory for the cluster that is in use.
		  EngineCPUUtilization::                          'EngineCPUUtilization',                             // Redis - Provides CPU utilization of the Redis engine thread. Because Redis is single-threaded, you can use this metric to analyze the load of the Redis process itself.
		  EvalBasedCmds::                                 'EvalBasedCmds',                                    // Redis - The total number of commands for eval-based commands.
		  EvalBasedCmdsLatency::                          'EvalBasedCmdsLatency',                             // Redis - Latency of eval-based commands.
		  Evictions::                                     'Evictions',                                        // Redis - The number of keys that have been evicted due to the maxmemory limit.
		  GeoSpatialBasedCmds::                           'GeoSpatialBasedCmds',                              // Redis - The total number of commands for geospatial-based commands.
		  GeoSpatialBasedCmdsLatency::                    'GeoSpatialBasedCmdsLatency',                       // Redis - Latency of geospatial-based commands.
		  GetTypeCmds::                                   'GetTypeCmds',                                      // Redis - The total number of read-only type commands.
		  GetTypeCmdsLatency::                            'GetTypeCmdsLatency',                               // Redis - Latency of read commands.
		  GlobalDatastoreReplicationLag::                 'GlobalDatastoreReplicationLag',                    // Redis - The lag between the secondary Region's primary node and the primary Region's primary node
		  HashBasedCmds::                                 'HashBasedCmds',                                    // Redis - The total number of commands that are hash-based.
		  HashBasedCmdsLatency::                          'HashBasedCmdsLatency',                             // Redis - Latency of hash-based commands.
		  HyperLogLogBasedCmds::                          'HyperLogLogBasedCmds',                             // Redis - The total number of HyperLogLog-based commands.
		  HyperLogLogBasedCmdsLatency::                   'HyperLogLogBasedCmdsLatency',                      // Redis - Latency of HyperLogLog-based commands.
		  IsMaster::                                      'IsMaster',                                         // Redis - Indicates whether the node is the primary node of current shard/cluster. The metric can be either 0 (not primary) or 1 (primary).
		  IsPrimary::                                     'IsPrimary',                                        // Redis -
		  KeyAuthorizationFailures::                      'KeyAuthorizationFailures',                         // Redis - The total number of failed attempts by users to access keys they don’t have permission to access.
		  KeyBasedCmds::                                  'KeyBasedCmds',                                     // Redis - The total number of commands that are key-based.
		  KeyBasedCmdsLatency::                           'KeyBasedCmdsLatency',                              // Redis - Latency of key-based commands.
		  KeysTracked::                                   'KeysTracked',                                      // Redis - The number of keys being tracked by Redis key tracking as a percentage of tracking-table-max-keys.
		  ListBasedCmds::                                 'ListBasedCmds',                                    // Redis - Redis - The total number of commands that are list-based.
		  ListBasedCmdsLatency::                          'ListBasedCmdsLatency',                             // Redis - Latency of list-based commands.
		  MasterLinkHealthStatus::                        'MasterLinkHealthStatus',                           // Redis - This status has two values: 0 or 1. The value 0 indicates that data in the ElastiCache primary node is not in sync with Redis on EC2. The value of 1 indicates that the data is in sync.
		  MemoryFragmentationRatio::                      'MemoryFragmentationRatio',                         // Redis - Indicates the efficiency in the allocation of memory of the Redis engine.
		  NewConnections::                                'NewConnections',                                   // Redis - The total number of connections that have been accepted by the server during this period.
		  NumItemsWrittenToDisk::                         'NumItemsWrittenToDisk',                            // Redis - The total number of items written to disk per minute.
		  PrimaryLinkHealthStatus::                       'PrimaryLinkHealthStatus',                          // Redis -
		  PubSubBasedCmds::                               'PubSubBasedCmds',                                  // Redis - The total number of commands for pub/sub functionality.
		  PubSubBasedCmdsLatency::                        'PubSubBasedCmdsLatency',                           // Redis - Latency of pub/sub-based commands.
		  Reclaimed::                                     'Reclaimed',                                        // Redis - The total number of key expiration events.
		  ReplicationBytes::                              'ReplicationBytes',                                 // Redis - For nodes in a replicated configuration, ReplicationBytes reports the number of bytes that the primary is sending to all of its replicas.
		  ReplicationLag::                                'ReplicationLag',                                   // Redis - This metric is only applicable for a node running as a read replica. It represents how far behind, in seconds, the replica is in applying changes from the primary node.
		  SaveInProgress::                                'SaveInProgress',                                   // Redis - This binary metric returns 1 whenever a background save (forked or forkless) is in progress, and 0 otherwise.
		  SetBasedCmds::                                  'SetBasedCmds',                                     // Redis - The total number of commands that are set-based.
		  SetBasedCmdsLatency::                           'SetBasedCmdsLatency',                              // Redis - Latency of set-based commands.
		  SetTypeCmds::                                   'SetTypeCmds',                                      // Redis - The total number of write types of commands.
		  SetTypeCmdsLatency::                            'SetTypeCmdsLatency',                               // Redis - Latency of write commands.
		  SortedSetBasedCmds::                            'SortedSetBasedCmds',                               // Redis - The total number of commands that are sorted set-based
		  SortedSetBasedCmdsLatency::                     'SortedSetBasedCmdsLatency',                        // Redis - Latency of sorted-based commands
		  StreamBasedCmds::                               'StreamBasedCmds',                                  // Redis - The total number of commands that are stream-based.
		  StreamBasedCmdsLatency::                        'StreamBasedCmdsLatency',                           // Redis - Latency of stream-based commands.
		  StringBasedCmds::                               'StringBasedCmds',                                  // Redis - The total number of commands that are string-based.
		  StringBasedCmdsLatency::                        'StringBasedCmdsLatency',                           // Redis - Latency of string-based commands
      ActiveDefragHits::                              'ActiveDefragHits',                                 // Redis - The number of value reallocations per minute performed by the active defragmentation process.
      NumItemsReadFromDisk::                          'NumItemsReadFromDisk',                             // Redis - The total number of items retrieved from disk per minute.
    },

    kms:: {
      SecondsUntilKeyMaterialExpiration::             'SecondsUntilKeyMaterialExpiration',                // The number of seconds remaining until the imported key material in a KMS key expires.
    },

    lambda:: {
      ConcurrentExecutions::                          'ConcurrentExecutions',                             // The number of function instances that are processing events.
      DeadLetterErrors::                              'DeadLetterErrors',                                 // For asynchronous invocation, the number of times that Lambda attempts to send an event to a dead-letter queue (DLQ) but fails.
      DestinationDeliveryFailures::                   'DestinationDeliveryFailures',                      // For asynchronous invocation and supported event source mappings, the number of times that Lambda attempts to send an event to a destination but fails.
      Duration::                                      'Duration',                                         // The amount of time that your function code spends processing an event.
      Errors::                                        'Errors',                                           // The number of invocations that result in a function error.
      Invocations::                                   'Invocations',                                      // The number of times that your function code is invoked, including successful invocations and invocations that result in a function error.
      IteratorAge::                                   'IteratorAge',                                      // For event source mappings that read from streams, the age of the last record in the event.
      OffsetLag::                                     'OffsetLag',                                        // For self-managed Apache Kafka and Amazon Managed Streaming for Apache Kafka (Amazon MSK) event sources, the difference in offset between the last record written to a topic and the last record that your function's consumer group processed.
      PostRuntimeExtensionsDuration::                 'PostRuntimeExtensionsDuration',                    // The cumulative amount of time that the runtime spends running code for extensions after the function code has completed.
      ProvisionedConcurrencyInvocations::             'ProvisionedConcurrencyInvocations',                // The number of times that the function code is invoked using provisioned concurrency.
      ProvisionedConcurrencyUtilization::             'ProvisionedConcurrencyUtilization',                // For a version or alias, the value of ProvisionedConcurrentExecutions divided by the total amount of provisioned concurrency allocated.
      ProvisionedConcurrentExecutions::               'ProvisionedConcurrentExecutions',                  // The number of function instances that are processing events using provisioned concurrency.
      Throttles::                                     'Throttles',                                        // The number of invocation requests that are throttled.
      ProvisionedConcurrencySpilloverInvocations::    'ProvisionedConcurrencySpilloverInvocations',       // The number of times that the function code is invoked using standard concurrency when all provisioned concurrency is in use.
      UnreservedConcurrentExecutions::                'UnreservedConcurrentExecutions',                   // For a Region, the number of events that functions without reserved concurrency are processing.
    },

    network_elb:: {
      ActiveFlowCount::                               'ActiveFlowCount',                                  // The total number of concurrent flows (or connections) from clients to targets.
      ActiveFlowCount_TLS::                           'ActiveFlowCount_TLS',                              // The total number of concurrent TLS flows (or connections) from clients to targets.
      ClientTLSNegotiationErrorCount::                'ClientTLSNegotiationErrorCount',                   // The total number of TLS handshakes that failed during negotiation between a client and a TLS listener.
      ConsumedLCUs::                                  'ConsumedLCUs',                                     // The number of load balancer capacity units (LCU) used by the load balancer.
      HealthyHostCount::                              'HealthyHostCount',                                 // The number of targets that are considered healthy.
      NewFlowCount::                                  'NewFlowCount',                                     // The total number of new flows (or connections) established from clients to targets in the time period.
      NewFlowCount_TLS::                              'NewFlowCount_TLS',                                 // The total number of new TLS flows (or connections) established from clients to targets in the time period.
      ProcessedBytes::                                'ProcessedBytes',                                   // The total number of bytes processed by the load balancer, including TCP/IP headers.
      ProcessedBytes_TLS::                            'ProcessedBytes_TLS',                               // The total number of bytes processed by TLS listeners.
      TCP_Client_Reset_Count::                        'TCP_Client_Reset_Count',                           // The total number of reset (RST) packets sent from a client to a target.
      TCP_ELB_Reset_Count::                           'TCP_ELB_Reset_Count',                              // The total number of reset (RST) packets generated by the load balancer.
      TCP_Target_Reset_Count::                        'TCP_Target_Reset_Count',                           // The total number of reset (RST) packets sent from a target to a client.
      TargetTLSNegotiationErrorCount::                'TargetTLSNegotiationErrorCount',                   // The total number of TLS handshakes that failed during negotiation between a TLS listener and a target.
      UnHealthyHostCount::                            'UnHealthyHostCount',                               // The number of targets that are considered unhealthy.
    },

    rds:: {
      AuroraGlobalDBDataTransferBytes::               'AuroraGlobalDBDataTransferBytes',                  // Aurora - Cluster - MySQL/PostgreSQL  - The amount of redo log data transferred from the master AWS Region to a secondary AWS Region.
      AuroraGlobalDBProgressLag::                     'AuroraGlobalDBProgressLag',                        // Aurora - Cluster - MySQL/PostgreSQL  - The measure of how far the secondary cluster is behind the primary cluster for both user transactions and system transactions.
      AuroraGlobalDBReplicatedWriteIO::               'AuroraGlobalDBReplicatedWriteIO',                  // Aurora - Cluster - MySQL/PostgreSQL  - The number of write I/O operations replicated from the primary AWS Region to the cluster volume in a secondary AWS Region.
      AuroraGlobalDBReplicationLag::                  'AuroraGlobalDBReplicationLag',                     // Aurora - Cluster - MySQL/PostgreSQL  - The amount of lag when replicating updates from the primary AWS Region.
      AuroraGlobalDBRPOLag::                          'AuroraGlobalDBRPOLag',                             // Aurora - Cluster - MySQL/PostgreSQL  - The recovery point objective (RPO) lag time.
      AuroraVolumeBytesLeftTotal::                    'AuroraVolumeBytesLeftTotal',                       // Aurora - Cluster - MySQL             - The remaining available space for the cluster volume.
      BacktrackChangeRecordsCreationRate::            'BacktrackChangeRecordsCreationRate',               // Aurora - Cluster - MySQL             - The number of backtrack change records created over 5 minutes for the DB cluster.
      BacktrackChangeRecordsStored::                  'BacktrackChangeRecordsStored',                     // Aurora - Cluster - MySQL             - The number of backtrack change records used by the DB cluster.
      BackupRetentionPeriodStorageUsed::              'BackupRetentionPeriodStorageUsed',                 // Aurora - Cluster - MySQL/PostgreSQL  - The total amount of backup storage used to support the point-in-time restore feature within the Aurora DB cluster's backup retention window.
      ServerlessDatabaseCapacity::                    'ServerlessDatabaseCapacity',                       // Aurora - Cluster - MySQL/PostgreSQL  - The current capacity of the serverless DB cluster.
      SnapshotStorageUsed::                           'SnapshotStorageUsed',                              // Aurora - Cluster - MySQL/PostgreSQL  - The total amount of backup storage consumed by all Aurora snapshots for an Aurora DB cluster outside its backup retention window.
      TotalBackupStorageBilled::                      'TotalBackupStorageBilled',                         // Aurora - Cluster - MySQL/PostgreSQL  - The total amount of backup storage in bytes for which you are billed for a given Aurora DB cluster.
      VolumeBytesUsed::                               'VolumeBytesUsed',                                  // Aurora - Cluster - MySQL/PostgreSQL  - The amount of storage used by your Aurora DB instance.
      VolumeReadIOPs::                                'VolumeReadIOPs',                                   // Aurora - Cluster - MySQL/PostgreSQL  - The number of billed read I/O operations from a cluster volume within a 5-minute interval.
      VolumeWriteIOPs::                               'VolumeWriteIOPs',                                  // Aurora - Cluster - MySQL/PostgreSQL  - The number of write disk I/O operations to the cluster volume, reported at 5-minute intervals.

      AbortedClients::                                'AbortedClients',                                   // Aurora - Instance - MySQL            - The number of client connections that have not been closed properly.
      ActiveTransactions::                            'ActiveTransactions',                               // Aurora - Instance - MySQL            - The average number of current transactions executing on an Aurora database instance per second.
      ACUUtilization::                                'ACUUtilization',                                   // Aurora - Instance - MySQL/PostgreSQL - The average number of current transactions executing on an Aurora database instance per second.
      AuroraBinlogReplicaLag::                        'AuroraBinlogReplicaLag',                           // Aurora - Instance - MySQL            - The amount of time that a binary log replica DB cluster running on Aurora MySQL-Compatible Edition lags behind the binary log replication source in s.
      AuroraReplicaLag::                              'AuroraReplicaLag',                                 // Aurora - Instance - MySQL/PostgreSQL - For an Aurora replica, the amount of lag when replicating updates from the primary instance in ms.
      AuroraReplicaLagMaximum::                       'AuroraReplicaLagMaximum',                          // Aurora - Instance - MySQL/PostgreSQL - The maximum amount of lag between the primary instance and any of the Aurora DB instance in the DB cluster in ms.
      AuroraReplicaLagMinimum::                       'AuroraReplicaLagMinimum',                          // Aurora - Instance - MySQL/PostgreSQL - The minimum amount of lag between the primary instance and any of the Aurora DB instance in the DB cluster in ms.
      AuroraSlowConnectionHandleCount::               'AuroraSlowConnectionHandleCount',                  // Aurora - Instance - MySQL            - The number of connections that have waited two seconds or longer to start the handshake.
      AuroraSlowHandshakeCount::                      'AuroraSlowHandshakeCount',                         // Aurora - Instance - MySQL            - The number of connections that have taken 50 milliseconds or longer to finish the handshake.
      BacktrackWindowActual::                         'BacktrackWindowActual',                            // Aurora - Instance - MySQL            - The difference between the target backtrack window and the actual backtrack window.
      BacktrackWindowAlert::                          'BacktrackWindowAlert',                             // Aurora - Instance - MySQL            - The number of times that the actual backtrack window is smaller than the target backtrack window for a given period of time.
      BlockedTransactions::                           'BlockedTransactions',                              // Aurora - Instance - MySQL            - The average number of transactions in the database that are blocked per second.
      BufferCacheHitRatio::                           'BufferCacheHitRatio',                              // Aurora - Instance - MySQL/PostgreSQL - The percentage of requests that are served by the buffer cache.
      CommitLatency::                                 'CommitLatency',                                    // Aurora - Instance - MySQL/PostgreSQL - The average duration of commit operations.
      CommitThroughput::                              'CommitThroughput',                                 // Aurora - Instance - MySQL/PostgreSQL - The average number of commit operations per second.
      ConnectionAttempts::                            'ConnectionAttempts',                               // Aurora - Instance - MySQL/PostgreSQL - The number of attempts to connect to an instance, whether successful or not.
      CPUCreditBalance::                              'CPUCreditBalance',                                 // Aurora - Instance - MySQL/PostgreSQL - The number of CPU credits that an instance has accumulated, reported at 5-minute intervals.
      CPUCreditUsage::                                'CPUCreditUsage',                                   // Aurora - Instance - MySQL/PostgreSQL - The number of CPU credits consumed during the specified period, reported at 5-minute intervals.
      CPUUtilization::                                'CPUUtilization',                                   // Aurora - Instance - MySQL/PostgreSQL - The percentage of CPU used by an Aurora DB instance.
      DatabaseConnections::                           'DatabaseConnections',                              // Aurora - Instance - MySQL/PostgreSQL - The number of client network connections to the database instance.
      DDLLatency::                                    'DDLLatency',                                       // Aurora - Instance - MySQL            - The average duration of requests such as example, create, alter, and drop requests.
      DDLThroughput::                                 'DDLThroughput',                                    // Aurora - Instance - MySQL/PostgreSQL - The average number of DDL requests per second.
      Deadlocks::                                     'Deadlocks',                                        // Aurora - Instance - MySQL/PostgreSQL - The average number of deadlocks in the database per second.
      DeleteLatency::                                 'DeleteLatency',                                    // Aurora - Instance - MySQL            - The average duration of delete operations
      DeleteThroughput::                              'DeleteThroughput',                                 // Aurora - Instance - MySQL            - The average number of delete queries per second.
      DiskQueueDepth::                                'DiskQueueDepth',                                   // Aurora - Instance - MySQL/PostgreSQL - The number of outstanding read/write requests waiting to access the disk.
      DMLLatency::                                    'DMLLatency',                                       // Aurora - Instance - MySQL            - The average duration of inserts, updates, and deletes.
      DMLThroughput::                                 'DMLThroughput',                                    // Aurora - Instance - MySQL            - The average number of inserts, updates, and deletes per second.
      EBSByteBalance::                                'EBSByteBalance%',                                  // Aurora - Instance - MySQL/PostgreSQL - The percentage of throughput credits remaining in the burst bucket of the RDS database.
      EBSIOBalance::                                  'EBSIOBalance%',                                    // Aurora - Instance - MySQL/PostgreSQL - The percentage of I/O credits remaining in the burst bucket of the RDS database.
      EngineUptime::                                  'EngineUptime',                                     // Aurora - Instance - MySQL/PostgreSQL - The amount of time that the instance has been running.
      FreeableMemory::                                'FreeableMemory',                                   // Aurora - Instance - MySQL/PostgreSQL - The amount of available random access memory.
      FreeLocalStorage::                              'FreeLocalStorage',                                 // Aurora - Instance - MySQL/PostgreSQL - The amount of local storage available.
      InsertLatency::                                 'InsertLatency',                                    // Aurora - Instance - MySQL            - The average duration of insert operations.
      InsertThroughput::                              'InsertThroughput',                                 // Aurora - Instance - MySQL            - The average number of insert operations per second.
      LoginFailures::                                 'LoginFailures',                                    // Aurora - Instance - MySQL            - The average number of failed login attempts per second.
      MaximumUsedTransactionIDs::                     'MaximumUsedTransactionIDs',                        // Aurora - Instance - PostgreSQL       - The age of the oldest unvacuumed transaction ID, in transactions.
      NetworkReceiveThroughput::                      'NetworkReceiveThroughput',                         // Aurora - Instance - MySQL/PostgreSQL - The amount of network throughput received from clients by each instance in the Aurora MySQL DB cluster.
      NetworkThroughput::                             'NetworkThroughput',                                // Aurora - Instance - MySQL/PostgreSQL - The amount of network throughput both received from and transmitted to clients by each instance in the Aurora MySQL DB cluster.
      NetworkTransmitThroughput::                     'NetworkTransmitThroughput',                        // Aurora - Instance - MySQL/PostgreSQL - The amount of network throughput sent to clients by each instance in the Aurora DB cluster.
      NumBinaryLogFiles::                             'NumBinaryLogFiles',                                // Aurora - Instance - MySQL            - The number of binlog files generated.
      Queries::                                       'Queries',                                          // Aurora - Instance - MySQL            - The average number of queries executed per second.
      RDSToAuroraPostgreSQLReplicaLag::               'RDSToAuroraPostgreSQLReplicaLag',                  // Aurora - Instance - PostgreSQL       - The lag when replicating updates from the primary RDS PostgreSQL instance to other nodes in the cluster
      ReadIOPS::                                      'ReadIOPS',                                         // Aurora - Instance - MySQL/PostgreSQL - The average number of disk I/O operations per second but the reports read and write separately, in 1-minute intervals.
      ReadLatency::                                   'ReadLatency',                                      // Aurora - Instance - MySQL/PostgreSQL - The average amount of time taken per disk I/O operation.
      ReadThroughput::                                'ReadThroughput',                                   // Aurora - Instance - MySQL/PostgreSQL - The average number of bytes read from disk per second.
      ReplicationSlotDiskUsage::                      'ReplicationSlotDiskUsage',                         // Aurora - Instance - PostgreSQL       - The amount of disk space consumed by replication slot files.
      ResultSetCacheHitRatio::                        'ResultSetCacheHitRatio',                           // Aurora - Instance - MySQL            - The percentage of requests that are served by the Resultset cache.
      RollbackSegmentHistoryListLength::              'RollbackSegmentHistoryListLength',                 // Aurora - Instance - MySQL            - The undo logs that record committed transactions with delete-marked records. These records are scheduled to be processed by the InnoDB purge operation.
      RowLockTime::                                   'RowLockTime',                                      // Aurora - Instance - MySQL            - The total time spent acquiring row locks for InnoDB tables.
      SelectLatency::                                 'SelectLatency',                                    // Aurora - Instance - MySQL            - The average amount of time for select operations.
      SelectThroughput::                              'SelectThroughput',                                 // Aurora - Instance - MySQL            - The average number of select queries per second.
      StorageNetworkReceiveThroughput::               'StorageNetworkReceiveThroughput',                  // Aurora - Instance - MySQL/PostgreSQL - The amount of network throughput received from the Aurora storage subsystem by each instance in the DB cluster.
      StorageNetworkThroughput::                      'StorageNetworkThroughput',                         // Aurora - Instance - MySQL/PostgreSQL - The amount of network throughput received from and sent to the Aurora storage subsystem by each instance in the Aurora MySQL DB cluster.
      StorageNetworkTransmitThroughput::              'StorageNetworkTransmitThroughput',                 // Aurora - Instance - MySQL/PostgreSQL - The amount of network throughput sent to the Aurora storage subsystem by each instance in the Aurora MySQL DB cluster.
      SumBinaryLogSize::                              'SumBinaryLogSize',                                 // Aurora - Instance - MySQL            - The total size of the binlog files.
      SwapUsage::                                     'SwapUsage',                                        // Aurora - Instance - MySQL/PostgreSQL - The amount of swap space used.
      TempStorageIOPS::                               'TempStorageIOPS',                                  // Aurora - Instance - MySQL/PostgreSQL - The number of IOPS for both read and writes on local storage attached to the DB instance. This metric represents a count and is measured once per second.
      TempStorageThroughput::                         'TempStorageThroughput',                            // Aurora - Instance - MySQL/PostgreSQL - The amount of data transferred to and from local storage associated with the DB instance. This metric represents bytes and is measured once per second.
      TransactionLogsDiskUsage::                      'TransactionLogsDiskUsage',                         // Aurora - Instance - PostgreSQL       - The amount of disk space consumed by transaction logs on the Aurora PostgreSQL DB instance.
      UpdateLatency::                                 'UpdateLatency',                                    // Aurora - Instance - MySQL            - The average amount of time taken for update operations.
      UpdateThroughput::                              'UpdateThroughput',                                 // Aurora - Instance - MySQL            - The average number of updates per second.
      WriteIOPS::                                     'WriteIOPS',                                        // Aurora - Instance - MySQL/PostgreSQL - The number of Aurora storage write records generated per second.
      WriteLatency::                                  'WriteLatency',                                     // Aurora - Instance - MySQL/PostgreSQL - The average amount of time taken per disk I/O operation.
      WriteThroughput::                               'WriteThroughput',                                  // Aurora - Instance - MySQL/PostgreSQL - The average number of bytes written to persistent storage every second.

      AvailabilityPercentage::                        'AvailabilityPercentage',                           // Proxy - The percentage of time for which the target group was available in the role indicated by the dimension. This metric is reported every minute. The most useful statistic for this metric is Average.
      ClientConnections::                             'ClientConnections',                                // Proxy - The current number of client connections. This metric is reported every minute. The most useful statistic for this metric is Sum.
      ClientConnectionsClosed::                       'ClientConnectionsClosed',                          // Proxy - The number of client connections closed. The most useful statistic for this metric is Sum.
      ClientConnectionsNoTLS::                        'ClientConnectionsNoTLS',                           // Proxy - The current number of client connections without Transport Layer Security (TLS). This metric is reported every minute. The most useful statistic for this metric is Sum.
      ClientConnectionsReceived::                     'ClientConnectionsReceived',                        // Proxy - The number of client connection requests received. The most useful statistic for this metric is Sum.
      ClientConnectionsSetupFailedAuth::              'ClientConnectionsSetupFailedAuth',                 // Proxy - The number of client connection attempts that failed due to misconfigured authentication or TLS. The most useful statistic for this metric is Sum.
      ClientConnectionsSetupSucceeded::               'ClientConnectionsSetupSucceeded',                  // Proxy - The number of client connections successfully established with any authentication mechanism with or without TLS. The most useful statistic for this metric is Sum.
      ClientConnectionsTLS::                          'ClientConnectionsTLS',                             // Proxy - The current number of client connections with TLS. This metric is reported every minute. The most useful statistic for this metric is Sum.
      DatabaseConnectionRequests::                    'DatabaseConnectionRequests',                       // Proxy - The number of requests to create a database connection. The most useful statistic for this metric is Sum.
      DatabaseConnectionRequestsWithTLS::             'DatabaseConnectionRequestsWithTLS',                // Proxy - The number of requests to create a database connection with TLS. The most useful statistic for this metric is Sum.
      DatabaseConnectionsBorrowLatency::              'DatabaseConnectionsBorrowLatency',                 // Proxy - The time in microseconds that it takes for the proxy being monitored to get a database connection. The most useful statistic for this metric is Average.
      DatabaseConnectionsCurrentlyBorrowed::          'DatabaseConnectionsCurrentlyBorrowed',             // Proxy - The current number of database connections in the borrow state. This metric is reported every minute. The most useful statistic for this metric is Sum.
      DatabaseConnectionsCurrentlyInTransaction::     'DatabaseConnectionsCurrentlyInTransaction',        // Proxy - The current number of database connections in a transaction. This metric is reported every minute. The most useful statistic for this metric is Sum.
      DatabaseConnectionsCurrentlySessionPinned::     'DatabaseConnectionsCurrentlySessionPinned',        // Proxy - The current number of database connections currently pinned because of operations in client requests that change session state. This metric is reported every minute. The most useful statistic for this metric is Sum.
      DatabaseConnectionsSetupFailed::                'DatabaseConnectionsSetupFailed',                   // Proxy - The number of database connection requests that failed. The most useful statistic for this metric is Sum.
      DatabaseConnectionsSetupSucceeded::             'DatabaseConnectionsSetupSucceeded',                // Proxy - The number of database connections successfully established with or without TLS. The most useful statistic for this metric is Sum.
      DatabaseConnectionsWithTLS::                    'DatabaseConnectionsWithTLS',                       // Proxy - The current number of database connections with TLS. This metric is reported every minute. The most useful statistic for this metric is Sum.
      MaxDatabaseConnectionsAllowed::                 'MaxDatabaseConnectionsAllowed',                    // Proxy - The maximum number of database connections allowed. This metric is reported every minute. The most useful statistic for this metric is Sum.
      QueryDatabaseResponseLatency::                  'QueryDatabaseResponseLatency',                     // Proxy - The time in microseconds that the database took to respond to the query. The most useful statistic for this metric is Average.
      QueryRequests::                                 'QueryRequests',                                    // Proxy - The number of queries received. A query including multiple statements is counted as one query. The most useful statistic for this metric is Sum.
      QueryRequestsNoTLS::                            'QueryRequestsNoTLS',                               // Proxy - The number of queries received from non-TLS connections. A query including multiple statements is counted as one query. The most useful statistic for this metric is Sum.
      QueryRequestsTLS::                              'QueryRequestsTLS',                                 // Proxy - The number of queries received from TLS connections. A query including multiple statements is counted as one query. The most useful statistic for this metric is Sum.
      QueryResponseLatency::                          'QueryResponseLatency',                             // Proxy - The time in microseconds between getting a query request and the proxy responding to it. The most useful statistic for this metric is Average.

      BinLogDiskUsage::                               'BinLogDiskUsage',                                  // The amount of disk space occupied by binary logs. If automatic backups are enabled for MySQL and MariaDB instances, including read replicas, binary logs are created.
      BurstBalance::                                  'BurstBalance',                                     // The percent of General Purpose SSD (gp2) burst-bucket I/O credits available.
      FailedSQLServerAgentJobsCount::                 'FailedSQLServerAgentJobsCount',                    // The number of failed Microsoft SQL Server Agent jobs during the last minute.
      FreeStorageSpace::                              'FreeStorageSpace',                                 // The amount of available storage space.
      OldestReplicationSlotLag::                      'OldestReplicationSlotLag',                         // The lagging size of the replica lagging the most in terms of write-ahead log (WAL) data received. Applies to PostgreSQL.
      ReplicaLag::                                    'ReplicaLag',                                       // For read replica configurations, the amount of time in seconds a read replica DB instance lags behind the source DB instance. Applies to MariaDB, Microsoft SQL Server, MySQL, Oracle, and PostgreSQL read replicas.
      TransactionLogsGeneration::                     'TransactionLogsGeneration',                        // The size of transaction logs generated per second. Applies to PostgreSQL.
    },

    route53:: {
      ChildHealthCheckHealthyCount::                  'ChildHealthCheckHealthyCount',                     // Health Checks - For a calculated health check, the number of health checks that are healthy among the health checks that Route 53 is monitoring.
      ConnectionTime::                                'ConnectionTime',                                   // Health Checks - The average time, in milliseconds, that it took Route 53 health checkers to establish a TCP connection with the endpoint.
      HealthCheckPercentageHealthy::                  'HealthCheckPercentageHealthy',                     // Health Checks - The percentage of Route 53 health checkers that consider the selected endpoint to be healthy.
      HealthCheckStatus::                             'HealthCheckStatus',                                // Health Checks - The status of the health check endpoint that CloudWatch is checking. 1 indicates healthy, and 0 indicates unhealthy.
      SSLHandshakeTime::                              'SSLHandshakeTime',                                 // Health Checks - The average time, in milliseconds, that it took Route 53 health checkers to complete the SSL handshake.
      TimeToFirstByte::                               'TimeToFirstByte',                                  // Health Checks - The average time, in milliseconds, that it took Route 53 health checkers to receive the first byte of the response to an HTTP or HTTPS request

      DNSQueries::                                    'DNSQueries',                                       // Hosted Zones - For all the records in a hosted zone, the number of DNS queries that Route 53 responds to in a specified time period.
      DNSSECInternalFailure::                         'DNSSECInternalFailure',                            // Hosted Zones - Value is 1 if any object in the hosted zone is in an INTERNAL_FAILURE state. Otherwise, value is 0.
      DNSSECKeySigningKeysNeedingAction::             'DNSSECKeySigningKeysNeedingAction',                // Hosted Zones - Number of key signing keys (KSKs) that have an ACTION_NEEDED state (due to KMS failure).
      DNSSECKeySigningKeyMaxNeedingActionAge::        'DNSSECKeySigningKeyMaxNeedingActionAge',           // Hosted Zones - Time elapsed since the key signing key (KSK) was set to the ACTION_NEEDED state.
      DNSSECKeySigningKeyAge::                        'DNSSECKeySigningKeyAge',                           // Hosted Zones - The time elapsed since the key signing key (KSK) was created (not since it was activated).
    },

    route53resolver:: {
      EndpointHealthyENICount::                       'EndpointHealthyENICount',                          // Endpoints    - The number of elastic network interfaces in the OPERATIONAL status.
      EndpointUnHealthyENICount::                     'EndpointUnHealthyENICount',                        // Endpoints    - The number of elastic network interfaces in the AUTO_RECOVERING status.
      InboundQueryVolume::                            'InboundQueryVolume',                               // Endpoints/IP - The number of DNS queries forwarded from the network to VPCs through the endpoint/IP.
      OutboundQueryAggregatedVolume::                 'OutboundQueryAggregatedVolume',                    // Endpoints/IP - The total number of DNS queries forwarded from VPCs to the network.
      OutboundQueryVolume::                           'OutboundQueryVolume',                              // Endpoints    - The number of DNS queries forwarded from VPCs to the network through the endpoint.


    },

    s3:: {
      AllRequests::                                   'AllRequests',                                      // The total number of HTTP requests made to an Amazon S3 bucket, regardless of type.
      BucketSizeBytes::                               'BucketSizeBytes',                                  // The amount of data in bytes that is stored in a bucket.
      BytesDownloaded::                               'BytesDownloaded',                                  // The number of bytes downloaded for requests made to an Amazon S3 bucket, where the response includes a body.
      BytesUploaded::                                 'BytesUploaded',                                    // The number of bytes uploaded for requests made to an Amazon S3 bucket, where the request includes a body.
      DeleteRequests::                                'DeleteRequests',                                   // The number of HTTP DELETE requests made for objects in an Amazon S3 bucket.
      Errors4xx::                                     '4xxErrors',                                        // The number of HTTP 4xx client error status code requests made to an Amazon S3 bucket with a value of either 0 or 1.
      Errors5xx::                                     '5xxErrors',                                        // The number of HTTP 5xx server error status code requests made to an Amazon S3 bucket with a value of either 0 or 1.
      FirstByteLatency::                              'FirstByteLatency',                                 // The per-request time from the complete request being received by an Amazon S3 bucket to when the response starts to be returned.
      GetRequests::                                   'GetRequests',                                      // The number of HTTP GET requests made for objects in an Amazon S3 bucket.
      HeadRequests::                                  'HeadRequests',                                     // The number of HTTP HEAD requests made to an Amazon S3 bucket.
      ListRequests::                                  'ListRequests',                                     // The number of HTTP requests that list the contents of a bucket.
      NumberOfObjects::                               'NumberOfObjects',                                  // The total number of objects stored in a bucket for all storage classes.
      PostRequests::                                  'PostRequests',                                     // The number of HTTP POST requests made to an Amazon S3 bucket.
      PutRequests::                                   'PutRequests',                                      // The number of HTTP PUT requests made for objects in an Amazon S3 bucket.
      SelectBytesReturned::                           'SelectBytesReturned',                              // The number of bytes of data returned with Amazon S3 SELECT Object Content requests in an Amazon S3 bucket.
      SelectBytesScanned::                            'SelectBytesScanned',                               // The number of bytes of data scanned with Amazon S3 SELECT Object Content requests in an Amazon S3 bucket
      SelectRequests::                                'SelectRequests',                                   // The number of Amazon S3 SELECT Object Content requests made for objects in an Amazon S3 bucket.
      TotalRequestLatency::                           'TotalRequestLatency',                              // The elapsed per-request time from the first byte received to the last byte sent to an Amazon S3 bucket.
    },
  },
}
