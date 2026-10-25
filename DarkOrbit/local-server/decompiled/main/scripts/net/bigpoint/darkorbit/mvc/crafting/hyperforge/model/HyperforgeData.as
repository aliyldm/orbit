package net.bigpoint.darkorbit.mvc.crafting.hyperforge.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.QuantumFluidCoreData;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class HyperforgeData
   {
      
      public var moduleDict:Dictionary;
      
      public const dataChanged:ISignal = new Signal();
      
      public function HyperforgeData()
      {
         super();
      }
      
      public function update(param1:Vector.<QuantumFluidCoreData>) : void
      {
         var _loc3_:QuantumFluidCoreData = null;
         this.moduleDict = new Dictionary();
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(this.moduleDict[_loc3_.lootId] == undefined)
            {
               this.moduleDict[_loc3_.lootId] = [];
            }
            this.moduleDict[_loc3_.lootId].push(_loc3_);
            _loc2_++;
         }
         this.dataChanged.dispatch();
      }
   }
}

