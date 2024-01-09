from mage_ai.data_preparation.models.pipeline import Pipeline
from mage_ai.orchestration.db.models.schedules import PipelineRun, BlockRun

from mage_ai.shared.hash import ignore_keys
from mage_ai.orchestration.db import db_connection
db_connection.start_session()



br = BlockRun.query.get(1054)
pr = PipelineRun.query.get(br.pipeline_run_id)


p = Pipeline.get('dynamic_replica_blocks')

b = p.get_block(br.block_uuid)

b.fetch_input_variables(None,
    execution_partition=pr.execution_partition,
    **ignore_keys(br.metrics, ['metadata'])
    )

# arr = [] 
# for idx, id in enumerate([400, 410, 411, 412]):
#     br = BlockRun.query.get(id)

#     b = p.get_block(br.block_uuid)


from mage_ai.shared.hash import ignore_keys
from mage_ai.orchestration.db import db_connection
db_connection.start_session()



br = BlockRun.query.get(1054)
pr = PipelineRun.query.get(br.pipeline_run_id)


p = Pipeline.get('dynamic_replica_blocks')

b = p.get_block(br.block_uuid)

b.fetch_input_variables(None,
    execution_partition=pr.execution_partition,
    **ignore_keys(br.metrics, ['metadata'])
    )

# arr = []
from mage_ai.shared.hash import ignore_keys
from mage_ai.orchestration.db import db_connection
db_connection.start_session()



br = BlockRun.query.get(1054)
pr = PipelineRun.query.get(br.pipeline_run_id)


p = Pipeline.get('dynamic_replica_blocks')

b = p.get_block(br.block_uuid)

b.fetch_input_variables(None,
    execution_partition=pr.execution_partition,
    **ignore_keys(br.metrics, ['metadata'])
    )

# arr = []
from mage_ai.shared.hash import ignore_keys
from mage_ai.orchestration.db import db_connection
db_connection.start_session()



br = BlockRun.query.get(1054)
pr = PipelineRun.query.get(br.pipeline_run_id)


p = Pipeline.get('dynamic_replica_blocks')

b = p.get_block(br.block_uuid)

b.fetch_input_variables(None,
    execution_partition=pr.execution_partition,
    **ignore_keys(br.metrics, ['metadata'])
    )

# arr = []
from mage_ai.shared.hash import ignore_keys
from mage_ai.orchestration.db import db_connection
db_connection.start_session()



br = BlockRun.query.get(1054)
pr = PipelineRun.query.get(br.pipeline_run_id)


p = Pipeline.get('dynamic_replica_blocks')

b = p.get_block(br.block_uuid)

b.fetch_input_variables(None,
    execution_partition=pr.execution_partition,
    **ignore_keys(br.metrics, ['metadata'])
    )

# arr = []


#     arr.append((br.block_uuid,b.get_outputs(
#         execution_partition=pr.execution_partition,
#     ) if idx == 0 else b.fetch_input_variables(None,
#     execution_partition=pr.execution_partition,
#     **ignore_keys(br.metrics, ['metadata'])
#     )))

# for t in arr:
#     print(t)
