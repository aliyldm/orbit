package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BlackListGetCommand implements IModule
   {
      
      private static var _instance:BlackListGetCommand;
      
      public var blackList:Vector.<int>;
      
      public var blackNameList:Vector.<String>;
      
      public function BlackListGetCommand(param1:Vector.<int> = null, param2:Vector.<String> = null)
      {
         super();
         if(param1 == null)
         {
            this.blackList = new Vector.<int>();
         }
         else
         {
            this.blackList = param1;
         }
         if(param2 == null)
         {
            this.blackNameList = new Vector.<String>();
         }
         else
         {
            this.blackNameList = param2;
         }
      }
      
      public static function get instance() : BlackListGetCommand
      {
         return _instance || (_instance = new BlackListGetCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13861;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.blackList.length > 0)
         {
            this.blackList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 13 % 32 | _loc4_ >>> 32 - 13 % 32;
            this.blackList.push(_loc4_);
            _loc2_++;
         }
         while(this.blackNameList.length > 0)
         {
            this.blackNameList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.blackNameList.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         param1.writeShort(-13861);
         param1.writeByte(this.blackList.length);
         for each(_loc2_ in this.blackList)
         {
            param1.writeInt(_loc2_ >>> 13 % 32 | _loc2_ << 32 - 13 % 32);
         }
         param1.writeByte(this.blackNameList.length);
         for each(_loc3_ in this.blackNameList)
         {
            param1.writeUTF(_loc3_);
         }
      }
   }
}

