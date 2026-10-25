package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.PulsingRingTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class BuffCapsule extends MapEntity
   {
      
      public function BuffCapsule(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"buffCapsule_" + param1.designId,UberAssetsLib.LIB_DEFAULT);
         addTrait(new PulsingRingTrait(true,400,2298413056,true,1));
      }
   }
}

