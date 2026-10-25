package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class NewQuestsAvailableCommand implements IModule
   {
      
      private static var _instance:NewQuestsAvailableCommand;
      
      public var newQuestIds:Vector.<int>;
      
      public function NewQuestsAvailableCommand(param1:Vector.<int> = null)
      {
         super();
         if(param1 == null)
         {
            this.newQuestIds = new Vector.<int>();
         }
         else
         {
            this.newQuestIds = param1;
         }
      }
      
      public static function get instance() : NewQuestsAvailableCommand
      {
         return _instance || (_instance = new NewQuestsAvailableCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21500;
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
         while(this.newQuestIds.length > 0)
         {
            this.newQuestIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 10 % 32 | _loc4_ << 32 - 10 % 32;
            this.newQuestIds.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(21500);
         param1.writeByte(this.newQuestIds.length);
         for each(_loc2_ in this.newQuestIds)
         {
            param1.writeInt(_loc2_ << 10 % 32 | _loc2_ >>> 32 - 10 % 32);
         }
      }
   }
}

