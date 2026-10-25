package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestListRemoveCommand implements IModule
   {
      
      private static var _instance:QuestListRemoveCommand;
      
      public var list:Vector.<int>;
      
      public function QuestListRemoveCommand(param1:Vector.<int> = null)
      {
         super();
         if(param1 == null)
         {
            this.list = new Vector.<int>();
         }
         else
         {
            this.list = param1;
         }
      }
      
      public static function get instance() : QuestListRemoveCommand
      {
         return _instance || (_instance = new QuestListRemoveCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12121;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 6 % 32 | _loc4_ << 32 - 6 % 32;
            this.list.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(12121);
         param1.writeShort(this.list.length);
         for each(_loc2_ in this.list)
         {
            param1.writeInt(_loc2_ << 6 % 32 | _loc2_ >>> 32 - 6 % 32);
         }
      }
   }
}

