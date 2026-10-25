package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuantumFluidCoreDataListCommand implements IModule
   {
      
      private static var _instance:QuantumFluidCoreDataListCommand;
      
      public var allModules:Vector.<QuantumFluidCoreData>;
      
      public function QuantumFluidCoreDataListCommand(param1:Vector.<QuantumFluidCoreData> = null)
      {
         super();
         if(param1 == null)
         {
            this.allModules = new Vector.<QuantumFluidCoreData>();
         }
         else
         {
            this.allModules = param1;
         }
      }
      
      public static function get instance() : QuantumFluidCoreDataListCommand
      {
         return _instance || (_instance = new QuantumFluidCoreDataListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 29283;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuantumFluidCoreData = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.allModules.length > 0)
         {
            this.allModules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuantumFluidCoreData(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.allModules.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuantumFluidCoreData = null;
         param1.writeShort(29283);
         param1.writeShort(this.allModules.length);
         for each(_loc2_ in this.allModules)
         {
            _loc2_.write(param1);
         }
      }
   }
}

