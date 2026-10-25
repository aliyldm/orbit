package net.bigpoint.darkorbit.com.module.porting.lockattributeitem
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class LockAttributeItemListCommand implements IModule
   {
      
      private static var _instance:LockAttributeItemListCommand;
      
      public var remove:Boolean = false;
      
      public var moduleList:Vector.<LockAttributeItemModule>;
      
      public function LockAttributeItemListCommand(param1:Vector.<LockAttributeItemModule> = null, param2:Boolean = false)
      {
         super();
         this.remove = param2;
         if(param1 == null)
         {
            this.moduleList = new Vector.<LockAttributeItemModule>();
         }
         else
         {
            this.moduleList = param1;
         }
      }
      
      public static function get instance() : LockAttributeItemListCommand
      {
         return _instance || (_instance = new LockAttributeItemListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18518;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LockAttributeItemModule = null;
         this.remove = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.moduleList.length > 0)
         {
            this.moduleList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LockAttributeItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.moduleList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LockAttributeItemModule = null;
         param1.writeShort(18518);
         param1.writeBoolean(this.remove);
         param1.writeShort(this.moduleList.length);
         for each(_loc2_ in this.moduleList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

