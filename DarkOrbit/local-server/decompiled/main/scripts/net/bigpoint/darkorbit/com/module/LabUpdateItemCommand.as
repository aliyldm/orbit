package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LabUpdateItemCommand implements IModule
   {
      
      private static var _instance:LabUpdateItemCommand;
      
      public var itemsUpdatedInfo:Vector.<UpdateItemModule>;
      
      public function LabUpdateItemCommand(param1:Vector.<UpdateItemModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.itemsUpdatedInfo = new Vector.<UpdateItemModule>();
         }
         else
         {
            this.itemsUpdatedInfo = param1;
         }
      }
      
      public static function get instance() : LabUpdateItemCommand
      {
         return _instance || (_instance = new LabUpdateItemCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 135;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UpdateItemModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.itemsUpdatedInfo.length > 0)
         {
            this.itemsUpdatedInfo.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UpdateItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.itemsUpdatedInfo.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UpdateItemModule = null;
         param1.writeShort(135);
         param1.writeByte(this.itemsUpdatedInfo.length);
         for each(_loc2_ in this.itemsUpdatedInfo)
         {
            _loc2_.write(param1);
         }
      }
   }
}

