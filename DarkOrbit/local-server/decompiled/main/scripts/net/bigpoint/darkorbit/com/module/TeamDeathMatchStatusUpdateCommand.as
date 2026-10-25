package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchStatusUpdateCommand implements IModule
   {
      
      private static var _instance:TeamDeathMatchStatusUpdateCommand;
      
      public var currentFactionScores:Vector.<FactionScoreModule>;
      
      public var maxScore:int = 0;
      
      public var remainingLifes:int = 0;
      
      public var remainingSeconds:int = 0;
      
      public var initSeconds:int = 0;
      
      public var overallEventScores:Vector.<FactionScoreModule>;
      
      public function TeamDeathMatchStatusUpdateCommand(param1:Vector.<FactionScoreModule> = null, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Vector.<FactionScoreModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.currentFactionScores = new Vector.<FactionScoreModule>();
         }
         else
         {
            this.currentFactionScores = param1;
         }
         this.maxScore = param2;
         this.remainingLifes = param3;
         this.remainingSeconds = param4;
         this.initSeconds = param5;
         if(param6 == null)
         {
            this.overallEventScores = new Vector.<FactionScoreModule>();
         }
         else
         {
            this.overallEventScores = param6;
         }
      }
      
      public static function get instance() : TeamDeathMatchStatusUpdateCommand
      {
         return _instance || (_instance = new TeamDeathMatchStatusUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1667;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 24;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:FactionScoreModule = null;
         var _loc5_:FactionScoreModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.currentFactionScores.length > 0)
         {
            this.currentFactionScores.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FactionScoreModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.currentFactionScores.push(_loc4_);
            _loc2_++;
         }
         this.maxScore = param1.readInt();
         this.maxScore = this.maxScore >>> 11 % 32 | this.maxScore << 32 - 11 % 32;
         this.remainingLifes = param1.readInt();
         this.remainingLifes = this.remainingLifes << 16 % 32 | this.remainingLifes >>> 32 - 16 % 32;
         this.remainingSeconds = param1.readInt();
         this.remainingSeconds = this.remainingSeconds << 4 % 32 | this.remainingSeconds >>> 32 - 4 % 32;
         this.initSeconds = param1.readInt();
         this.initSeconds = this.initSeconds << 11 % 32 | this.initSeconds >>> 32 - 11 % 32;
         while(this.overallEventScores.length > 0)
         {
            this.overallEventScores.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = FactionScoreModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.overallEventScores.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:FactionScoreModule = null;
         var _loc3_:FactionScoreModule = null;
         param1.writeShort(1667);
         param1.writeByte(this.currentFactionScores.length);
         for each(_loc2_ in this.currentFactionScores)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.maxScore << 11 % 32 | this.maxScore >>> 32 - 11 % 32);
         param1.writeInt(this.remainingLifes >>> 16 % 32 | this.remainingLifes << 32 - 16 % 32);
         param1.writeInt(this.remainingSeconds >>> 4 % 32 | this.remainingSeconds << 32 - 4 % 32);
         param1.writeInt(this.initSeconds >>> 11 % 32 | this.initSeconds << 32 - 11 % 32);
         param1.writeByte(this.overallEventScores.length);
         for each(_loc3_ in this.overallEventScores)
         {
            _loc3_.write(param1);
         }
      }
   }
}

