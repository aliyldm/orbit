package net.bigpoint.darkorbit.mvc.crafting.hyperforge.model
{
   import net.bigpoint.darkorbit.com.module.QuantumFluidCoreDataListCommand;
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class HyperforgeProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "HyperforgeProxy";
      
      private var _hyperforgedata:HyperforgeData = new HyperforgeData();
      
      public function HyperforgeProxy()
      {
         super(NAME,data);
      }
      
      public function setHyperforgeData(param1:QuantumFluidCoreDataListCommand) : void
      {
         this._hyperforgedata.update(param1.allModules);
      }
      
      public function getHyperForgeData() : HyperforgeData
      {
         return this._hyperforgedata;
      }
   }
}

