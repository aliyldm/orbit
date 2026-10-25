package net.bigpoint.darkorbit.map.model.env.homebase
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class HomeBaseLaserTurret extends MapEntity
   {
      
      public function HomeBaseLaserTurret(param1:AssetCreateCommand)
      {
         super(param1.assetId,new PointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"turret_" + param1.type.typeValue + "_" + param1.factionId,UberAssetsLib.LIB_DEFAULT);
      }
   }
}

