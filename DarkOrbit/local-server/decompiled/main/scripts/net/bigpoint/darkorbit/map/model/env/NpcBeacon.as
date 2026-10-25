package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class NpcBeacon extends MapEntity
   {
      
      private var _info:MapObjectInfoTrait;
      
      public function NpcBeacon(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"npc-beacon-" + param1.designId,UberAssetsLib.LIB_DEFAULT);
         addTrait(this._info = new MapObjectInfoTrait());
      }
   }
}

