from mage_ai.data_preparation.models.pipeline import Pipeline


p = Pipeline.get('precise_realm')

b = p.get_block('genuine_wildflower')

b.replicated_block_object.content