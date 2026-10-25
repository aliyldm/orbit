package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassStatusCommand implements IModule
   {
      
      private static var _instance:SeasonPassStatusCommand;
      
      public var pointsCost:Vector.<int>;
      
      public var uridiumCost:Vector.<int>;
      
      public var goldPass:Boolean = false;
      
      public var showTips:Boolean = false;
      
      public var marketingImage:String = "";
      
      public var seasonName:String = "";
      
      public var extGoldPass:Boolean = false;
      
      public var timeToEventEnd:Number = 0;
      
      public function SeasonPassStatusCommand(param1:Number = 0, param2:Boolean = false, param3:String = "", param4:String = "", param5:Vector.<int> = null, param6:Vector.<int> = null, param7:Boolean = false, param8:Boolean = false)
      {
         super();
         if(param5 == null)
         {
            this.pointsCost = new Vector.<int>();
         }
         else
         {
            this.pointsCost = param5;
         }
         if(param6 == null)
         {
            this.uridiumCost = new Vector.<int>();
         }
         else
         {
            this.uridiumCost = param6;
         }
         this.goldPass = param2;
         this.showTips = param8;
         this.marketingImage = param4;
         this.seasonName = param3;
         this.extGoldPass = param7;
         this.timeToEventEnd = param1;
      }
      
      public static function get instance() : SeasonPassStatusCommand
      {
         return _instance || (_instance = new SeasonPassStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -5303;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 23;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.pointsCost.length > 0)
         {
            this.pointsCost.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 10 % 32 | _loc4_ << 32 - 10 % 32;
            this.pointsCost.push(_loc4_);
            _loc2_++;
         }
         while(this.uridiumCost.length > 0)
         {
            this.uridiumCost.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 14 % 32 | _loc4_ << 32 - 14 % 32;
            this.uridiumCost.push(_loc4_);
            _loc2_++;
         }
         this.goldPass = param1.readBoolean();
         this.showTips = param1.readBoolean();
         this.marketingImage = param1.readUTF();
         this.seasonName = param1.readUTF();
         this.extGoldPass = param1.readBoolean();
         this.timeToEventEnd = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         param1.writeShort(-5303);
         param1.writeByte(this.pointsCost.length);
         for each(_loc2_ in this.pointsCost)
         {
            param1.writeInt(_loc2_ << 10 % 32 | _loc2_ >>> 32 - 10 % 32);
         }
         param1.writeByte(this.uridiumCost.length);
         for each(_loc3_ in this.uridiumCost)
         {
            param1.writeInt(_loc3_ << 14 % 32 | _loc3_ >>> 32 - 14 % 32);
         }
         param1.writeBoolean(this.goldPass);
         param1.writeBoolean(this.showTips);
         param1.writeUTF(this.marketingImage);
         param1.writeUTF(this.seasonName);
         param1.writeBoolean(this.extGoldPass);
         param1.writeDouble(this.timeToEventEnd);
      }
   }
}

