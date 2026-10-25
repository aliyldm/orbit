package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AvailableModulesCommand implements IModule
   {
      
      private static var _instance:AvailableModulesCommand;
      
      public var modules:Vector.<StationModuleModule>;
      
      public function AvailableModulesCommand(param1:Vector.<StationModuleModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.modules = new Vector.<StationModuleModule>();
         }
         else
         {
            this.modules = param1;
         }
      }
      
      public static function get instance() : AvailableModulesCommand
      {
         return _instance || (_instance = new AvailableModulesCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6001;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:StationModuleModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.modules.length > 0)
         {
            this.modules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = StationModuleModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.modules.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:StationModuleModule = null;
         param1.writeShort(6001);
         param1.writeShort(this.modules.length);
         for each(_loc2_ in this.modules)
         {
            _loc2_.write(param1);
         }
      }
   }
}

