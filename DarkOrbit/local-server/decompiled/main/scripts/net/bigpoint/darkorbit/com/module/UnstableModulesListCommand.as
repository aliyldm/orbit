package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnstableModulesListCommand implements IModule
   {
      
      private static var _instance:UnstableModulesListCommand;
      
      public var allModules:Vector.<UnstableModuleModule>;
      
      public var resetUI:Boolean = false;
      
      public var isDiscountRunning:Boolean = false;
      
      public var shardCommand:UnstableModulesShardCommand;
      
      public function UnstableModulesListCommand(param1:Vector.<UnstableModuleModule> = null, param2:UnstableModulesShardCommand = null, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.allModules = new Vector.<UnstableModuleModule>();
         }
         else
         {
            this.allModules = param1;
         }
         this.resetUI = param4;
         this.isDiscountRunning = param3;
         if(param2 == null)
         {
            this.shardCommand = new UnstableModulesShardCommand();
         }
         else
         {
            this.shardCommand = param2;
         }
      }
      
      public static function get instance() : UnstableModulesListCommand
      {
         return _instance || (_instance = new UnstableModulesListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13472;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UnstableModuleModule = null;
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
            _loc4_ = UnstableModuleModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.allModules.push(_loc4_);
            _loc2_++;
         }
         this.resetUI = param1.readBoolean();
         this.isDiscountRunning = param1.readBoolean();
         this.shardCommand = UnstableModulesShardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.shardCommand)
         {
            this.shardCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UnstableModuleModule = null;
         param1.writeShort(-13472);
         param1.writeShort(this.allModules.length);
         for each(_loc2_ in this.allModules)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.resetUI);
         param1.writeBoolean(this.isDiscountRunning);
         if(null != this.shardCommand)
         {
            this.shardCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

