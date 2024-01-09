from mage_ai.data_preparation.models.global_data_product import GlobalDataProduct
from mage_ai.data_preparation.models.pipeline import Pipeline
from mage_ai.orchestration.db.models.schedules import BlockRun, PipelineRun
from mage_ai.shared.hash import ignore_keys

from mage_ai.orchestration.db import db_connection
db_connection.start_session()

# block run 624




br = BlockRun.query.get(7121)
pr = br.pipeline_run
p = Pipeline.get('autumn_dream')

b = p.get_block(br.block_uuid)

b.fetch_input_variables(None, execution_partition=pr.execution_partition, 
**ignore_keys(br.metrics, [
    # 'metadata',
    # 'dynamic_block_index',
])
)
