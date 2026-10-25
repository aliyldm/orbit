package net.bigpoint.darkorbit.map.model.env
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.mvc.common.model.assets.UberAssetsLib;
   
   public class PlagueExplodinRange extends MapEntity
   {
      
      public function PlagueExplodinRange(param1:AssetCreateCommand)
      {
         super(param1.assetId,new BindablePointLite(param1.posX,param1.posY));
         UberAssetsLib.instance.fillTraits(this,"ranged_explosion",UberAssetsLib.LIB_DEFAULT);
      }
   }
}

