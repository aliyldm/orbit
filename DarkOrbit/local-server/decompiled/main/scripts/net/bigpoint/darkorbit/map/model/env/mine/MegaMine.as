package net.bigpoint.darkorbit.map.model.env.mine
{
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   
   public class MegaMine extends Mine
   {
      
      public function MegaMine(param1:AssetCreateCommand)
      {
         super(param1.posX,param1.posY,19,param1.assetId);
      }
   }
}

