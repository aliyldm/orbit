package net.bigpoint.darkorbit.map.model.env.mine
{
   import net.bigpoint.darkorbit.com.module.AssetCreateCommand;
   
   public class PlutusMine extends Mine
   {
      
      public function PlutusMine(param1:AssetCreateCommand)
      {
         super(param1.posX,param1.posY,18,param1.assetId);
      }
   }
}

