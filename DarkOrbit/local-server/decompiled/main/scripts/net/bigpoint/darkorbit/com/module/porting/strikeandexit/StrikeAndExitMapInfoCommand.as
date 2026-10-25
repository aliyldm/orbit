package net.bigpoint.darkorbit.com.module.porting.strikeandexit
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class StrikeAndExitMapInfoCommand implements IModule
   {
      
      private static var _instance:StrikeAndExitMapInfoCommand;
      
      public var spotLightUserY:int = 0;
      
      public var nextSpawnBossSeconds:int = 0;
      
      public var spotLightUserName:String = "";
      
      public var spotLightUserX:int = 0;
      
      public var npcRemainingQuantity:Vector.<int>;
      
      public var npcTypes:Vector.<int>;
      
      public var bossAlive:Boolean = false;
      
      public var boxRemainingQuantity:int = 0;
      
      public var boxType:String = "";
      
      public var remainingTime:int = 0;
      
      public var bossType:int = 0;
      
      public var nextSpawnSeconds:int = 0;
      
      public var stellarCoinLimit:int = 0;
      
      public function StrikeAndExitMapInfoCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:Vector.<int> = null, param5:Vector.<int> = null, param6:int = 0, param7:int = 0, param8:String = "", param9:int = 0, param10:int = 0, param11:Boolean = false, param12:int = 0, param13:int = 0)
      {
         super();
         this.spotLightUserY = param10;
         this.nextSpawnBossSeconds = param6;
         this.spotLightUserName = param8;
         this.spotLightUserX = param9;
         if(param5 == null)
         {
            this.npcRemainingQuantity = new Vector.<int>();
         }
         else
         {
            this.npcRemainingQuantity = param5;
         }
         if(param4 == null)
         {
            this.npcTypes = new Vector.<int>();
         }
         else
         {
            this.npcTypes = param4;
         }
         this.bossAlive = param11;
         this.boxRemainingQuantity = param3;
         this.boxType = param2;
         this.remainingTime = param13;
         this.bossType = param7;
         this.nextSpawnSeconds = param1;
         this.stellarCoinLimit = param12;
      }
      
      public static function get instance() : StrikeAndExitMapInfoCommand
      {
         return _instance || (_instance = new StrikeAndExitMapInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -4652;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 45;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.spotLightUserY = param1.readInt();
         this.spotLightUserY = this.spotLightUserY >>> 8 % 32 | this.spotLightUserY << 32 - 8 % 32;
         this.nextSpawnBossSeconds = param1.readInt();
         this.nextSpawnBossSeconds = this.nextSpawnBossSeconds << 16 % 32 | this.nextSpawnBossSeconds >>> 32 - 16 % 32;
         this.spotLightUserName = param1.readUTF();
         this.spotLightUserX = param1.readInt();
         this.spotLightUserX = this.spotLightUserX >>> 13 % 32 | this.spotLightUserX << 32 - 13 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.npcRemainingQuantity.length > 0)
         {
            this.npcRemainingQuantity.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 8 % 32 | _loc4_ << 32 - 8 % 32;
            this.npcRemainingQuantity.push(_loc4_);
            _loc2_++;
         }
         while(this.npcTypes.length > 0)
         {
            this.npcTypes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 4 % 32 | _loc4_ << 32 - 4 % 32;
            this.npcTypes.push(_loc4_);
            _loc2_++;
         }
         this.bossAlive = param1.readBoolean();
         this.boxRemainingQuantity = param1.readInt();
         this.boxRemainingQuantity = this.boxRemainingQuantity << 7 % 32 | this.boxRemainingQuantity >>> 32 - 7 % 32;
         this.boxType = param1.readUTF();
         this.remainingTime = param1.readInt();
         this.remainingTime = this.remainingTime >>> 8 % 32 | this.remainingTime << 32 - 8 % 32;
         this.bossType = param1.readInt();
         this.bossType = this.bossType << 10 % 32 | this.bossType >>> 32 - 10 % 32;
         this.nextSpawnSeconds = param1.readInt();
         this.nextSpawnSeconds = this.nextSpawnSeconds << 3 % 32 | this.nextSpawnSeconds >>> 32 - 3 % 32;
         this.stellarCoinLimit = param1.readInt();
         this.stellarCoinLimit = this.stellarCoinLimit >>> 13 % 32 | this.stellarCoinLimit << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         param1.writeShort(-4652);
         param1.writeInt(this.spotLightUserY << 8 % 32 | this.spotLightUserY >>> 32 - 8 % 32);
         param1.writeInt(this.nextSpawnBossSeconds >>> 16 % 32 | this.nextSpawnBossSeconds << 32 - 16 % 32);
         param1.writeUTF(this.spotLightUserName);
         param1.writeInt(this.spotLightUserX << 13 % 32 | this.spotLightUserX >>> 32 - 13 % 32);
         param1.writeByte(this.npcRemainingQuantity.length);
         for each(_loc2_ in this.npcRemainingQuantity)
         {
            param1.writeInt(_loc2_ << 8 % 32 | _loc2_ >>> 32 - 8 % 32);
         }
         param1.writeByte(this.npcTypes.length);
         for each(_loc3_ in this.npcTypes)
         {
            param1.writeInt(_loc3_ << 4 % 32 | _loc3_ >>> 32 - 4 % 32);
         }
         param1.writeBoolean(this.bossAlive);
         param1.writeInt(this.boxRemainingQuantity >>> 7 % 32 | this.boxRemainingQuantity << 32 - 7 % 32);
         param1.writeUTF(this.boxType);
         param1.writeInt(this.remainingTime << 8 % 32 | this.remainingTime >>> 32 - 8 % 32);
         param1.writeInt(this.bossType >>> 10 % 32 | this.bossType << 32 - 10 % 32);
         param1.writeInt(this.nextSpawnSeconds >>> 3 % 32 | this.nextSpawnSeconds << 32 - 3 % 32);
         param1.writeInt(this.stellarCoinLimit << 13 % 32 | this.stellarCoinLimit >>> 32 - 13 % 32);
      }
   }
}

