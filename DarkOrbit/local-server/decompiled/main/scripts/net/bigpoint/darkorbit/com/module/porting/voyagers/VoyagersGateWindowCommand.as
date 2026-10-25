package net.bigpoint.darkorbit.com.module.porting.voyagers
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class VoyagersGateWindowCommand implements IModule
   {
      
      private static var _instance:VoyagersGateWindowCommand;
      
      public var maxOpenLevel:int = 0;
      
      public var Star2Seconds:int = 0;
      
      public var curLootAmount:int = 0;
      
      public var Star1Seconds:int = 0;
      
      public var lootId:String = "";
      
      public var maxFreeNum:int = 0;
      
      public var freeChallengedNum:int = 0;
      
      public var starRewardLoots:Vector.<VoyagersGateStarRewardCommand>;
      
      public var Star3Seconds:int = 0;
      
      public function VoyagersGateWindowCommand(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:Vector.<VoyagersGateStarRewardCommand> = null)
      {
         super();
         this.maxOpenLevel = param5;
         this.Star2Seconds = param7;
         this.curLootAmount = param2;
         this.Star1Seconds = param6;
         this.lootId = param1;
         this.maxFreeNum = param4;
         this.freeChallengedNum = param3;
         if(param9 == null)
         {
            this.starRewardLoots = new Vector.<VoyagersGateStarRewardCommand>();
         }
         else
         {
            this.starRewardLoots = param9;
         }
         this.Star3Seconds = param8;
      }
      
      public static function get instance() : VoyagersGateWindowCommand
      {
         return _instance || (_instance = new VoyagersGateWindowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14061;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 34;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:VoyagersGateStarRewardCommand = null;
         this.maxOpenLevel = param1.readInt();
         this.maxOpenLevel = this.maxOpenLevel << 9 % 32 | this.maxOpenLevel >>> 32 - 9 % 32;
         this.Star2Seconds = param1.readInt();
         this.Star2Seconds = this.Star2Seconds >>> 14 % 32 | this.Star2Seconds << 32 - 14 % 32;
         this.curLootAmount = param1.readInt();
         this.curLootAmount = this.curLootAmount >>> 11 % 32 | this.curLootAmount << 32 - 11 % 32;
         this.Star1Seconds = param1.readInt();
         this.Star1Seconds = this.Star1Seconds >>> 6 % 32 | this.Star1Seconds << 32 - 6 % 32;
         this.lootId = param1.readUTF();
         this.maxFreeNum = param1.readInt();
         this.maxFreeNum = this.maxFreeNum >>> 14 % 32 | this.maxFreeNum << 32 - 14 % 32;
         this.freeChallengedNum = param1.readInt();
         this.freeChallengedNum = this.freeChallengedNum << 9 % 32 | this.freeChallengedNum >>> 32 - 9 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.starRewardLoots.length > 0)
         {
            this.starRewardLoots.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = VoyagersGateStarRewardCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.starRewardLoots.push(_loc4_);
            _loc2_++;
         }
         this.Star3Seconds = param1.readInt();
         this.Star3Seconds = this.Star3Seconds >>> 4 % 32 | this.Star3Seconds << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:VoyagersGateStarRewardCommand = null;
         param1.writeShort(14061);
         param1.writeInt(this.maxOpenLevel >>> 9 % 32 | this.maxOpenLevel << 32 - 9 % 32);
         param1.writeInt(this.Star2Seconds << 14 % 32 | this.Star2Seconds >>> 32 - 14 % 32);
         param1.writeInt(this.curLootAmount << 11 % 32 | this.curLootAmount >>> 32 - 11 % 32);
         param1.writeInt(this.Star1Seconds << 6 % 32 | this.Star1Seconds >>> 32 - 6 % 32);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.maxFreeNum << 14 % 32 | this.maxFreeNum >>> 32 - 14 % 32);
         param1.writeInt(this.freeChallengedNum >>> 9 % 32 | this.freeChallengedNum << 32 - 9 % 32);
         param1.writeByte(this.starRewardLoots.length);
         for each(_loc2_ in this.starRewardLoots)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.Star3Seconds << 4 % 32 | this.Star3Seconds >>> 32 - 4 % 32);
      }
   }
}

