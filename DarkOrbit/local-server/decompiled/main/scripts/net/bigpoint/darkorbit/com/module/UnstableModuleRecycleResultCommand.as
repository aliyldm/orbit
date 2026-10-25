package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnstableModuleRecycleResultCommand implements IModule
   {
      
      private static var _instance:UnstableModuleRecycleResultCommand;
      
      public var itemId:int = 0;
      
      public var shardCommand:UnstableModulesShardCommand;
      
      public function UnstableModuleRecycleResultCommand(param1:int = 0, param2:UnstableModulesShardCommand = null)
      {
         super();
         this.itemId = param1;
         if(param2 == null)
         {
            this.shardCommand = new UnstableModulesShardCommand();
         }
         else
         {
            this.shardCommand = param2;
         }
      }
      
      public static function get instance() : UnstableModuleRecycleResultCommand
      {
         return _instance || (_instance = new UnstableModuleRecycleResultCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1810;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.itemId = param1.readInt();
         this.itemId = this.itemId >>> 16 % 32 | this.itemId << 32 - 16 % 32;
         this.shardCommand = UnstableModulesShardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.shardCommand)
         {
            this.shardCommand.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1810);
         param1.writeInt(this.itemId << 16 % 32 | this.itemId >>> 32 - 16 % 32);
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

