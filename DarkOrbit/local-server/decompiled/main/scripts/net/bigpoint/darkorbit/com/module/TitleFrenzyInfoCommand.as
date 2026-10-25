package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TitleFrenzyInfoCommand implements IModule
   {
      
      private static var _instance:TitleFrenzyInfoCommand;
      
      public var schedule:TitleFrenzyScheduleUpdateCommand;
      
      public var timeToEventEnd:Number = 0;
      
      public var titleKey:String = "";
      
      public var rankRewards:Vector.<RankRewardRangeModule>;
      
      public var npcIds:Vector.<int>;
      
      public function TitleFrenzyInfoCommand(param1:Number = 0, param2:TitleFrenzyScheduleUpdateCommand = null, param3:String = "", param4:Vector.<int> = null, param5:Vector.<RankRewardRangeModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.schedule = new TitleFrenzyScheduleUpdateCommand();
         }
         else
         {
            this.schedule = param2;
         }
         this.timeToEventEnd = param1;
         this.titleKey = param3;
         if(param5 == null)
         {
            this.rankRewards = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.rankRewards = param5;
         }
         if(param4 == null)
         {
            this.npcIds = new Vector.<int>();
         }
         else
         {
            this.npcIds = param4;
         }
      }
      
      public static function get instance() : TitleFrenzyInfoCommand
      {
         return _instance || (_instance = new TitleFrenzyInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23966;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         var _loc5_:int = 0;
         this.schedule = TitleFrenzyScheduleUpdateCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.schedule)
         {
            this.schedule.read(param1);
         }
         this.timeToEventEnd = param1.readDouble();
         this.titleKey = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rankRewards.length > 0)
         {
            this.rankRewards.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rankRewards.push(_loc4_);
            _loc2_++;
         }
         while(this.npcIds.length > 0)
         {
            this.npcIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1.readInt();
            _loc5_ = _loc5_ << 7 % 32 | _loc5_ >>> 32 - 7 % 32;
            this.npcIds.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         var _loc3_:int = 0;
         param1.writeShort(23966);
         if(null != this.schedule)
         {
            this.schedule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeDouble(this.timeToEventEnd);
         param1.writeUTF(this.titleKey);
         param1.writeByte(this.rankRewards.length);
         for each(_loc2_ in this.rankRewards)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.npcIds.length);
         for each(_loc3_ in this.npcIds)
         {
            param1.writeInt(_loc3_ >>> 7 % 32 | _loc3_ << 32 - 7 % 32);
         }
      }
   }
}

