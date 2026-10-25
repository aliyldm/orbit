package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class BurningTrailEntity extends MapEntity
   {
      
      public function BurningTrailEntity(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"burning_trail_entity_" + param1.designId,UberAssetsLib.LIB_DEFAULT);
      }
   }
}

