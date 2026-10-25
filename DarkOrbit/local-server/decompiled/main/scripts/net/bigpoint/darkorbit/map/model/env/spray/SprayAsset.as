package net.bigpoint.darkorbit.map.model.env.spray
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class SprayAsset extends MapEntity
   {
      
      private const WIDTH_OFFSET:int = 200;
      
      private const HEIGHT_OFFSET:int = 130;
      
      public function SprayAsset(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX + this.WIDTH_OFFSET,param1.posY + this.HEIGHT_OFFSET));
         UberAssetsLib.instance.fillTraits(this,"spray_" + param1.designId,UberAssetsLib.LIB_DEFAULT);
      }
   }
}

