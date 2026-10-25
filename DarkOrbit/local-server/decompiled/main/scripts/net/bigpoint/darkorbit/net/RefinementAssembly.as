package net.bigpoint.darkorbit.net
{
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.com.module.UpdateItemModule;
   import net.bigpoint.darkorbit.refinement.RefinementManager;
   
   public class RefinementAssembly
   {
      
      private var main:Main;
      
      public function RefinementAssembly()
      {
         super();
      }
      
      public function setMain(param1:Main) : void
      {
         this.main = param1;
      }
      
      public function assembleRefinementUpdate(param1:Vector.<UpdateItemModule>) : void
      {
         var _loc2_:UpdateItemModule = null;
         for each(_loc2_ in param1)
         {
            this.main.getGuiManager().refinementManager.updateItem(RefinementManager.getItemTypeString(_loc2_.itemToUpdate.itemValue),_loc2_.oreCountToUpdateWith.oreType.typeValue,_loc2_.oreCountToUpdateWith.count);
         }
      }
   }
}

