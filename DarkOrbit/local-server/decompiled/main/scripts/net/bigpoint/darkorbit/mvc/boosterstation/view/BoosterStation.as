package net.bigpoint.darkorbit.mvc.boosterstation.view
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.minimap.traits.MiniMapDotTrait;
   import net.bigpoint.darkorbit.map.model.traits.PulsingRingTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class BoosterStation extends MapEntity
   {
      
      public function BoosterStation(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"boosterstation_" + param1.designId,UberAssetsLib.LIB_DEFAULT);
         addTrait(new PulsingRingTrait());
      }
      
      private function get pulsingRing() : PulsingRingTrait
      {
         return getFirstTrait(PulsingRingTrait) as PulsingRingTrait;
      }
      
      public function activate(param1:int) : void
      {
         this.pulsingRing.enable(param1,MiniMapDotTrait(getFirstTrait(MiniMapDotTrait)).color);
      }
      
      public function deactivate() : void
      {
         this.pulsingRing.disable();
      }
   }
}

