package net.bigpoint.darkorbit.com.module.porting.publicWorldBoss
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class PublicWorldBossInfoCommand implements IModule
   {
      
      private static var _instance:PublicWorldBossInfoCommand;
      
      public var publicWorldBossTierList:Vector.<PublicWorldBossTier>;
      
      public var timeToNextRaidSeconds:Number = 0;
      
      public var raiding:Boolean = false;
      
      public var timeToEventEndSeconds:Number = 0;
      
      public var currHealth:Number = 0;
      
      public var maxHealth:Number = 0;
      
      public var currTier:int = 0;
      
      public function PublicWorldBossInfoCommand(param1:Number = 0, param2:Number = 0, param3:int = 0, param4:Number = 0, param5:Number = 0, param6:Boolean = false, param7:Vector.<PublicWorldBossTier> = null)
      {
         super();
         if(param7 == null)
         {
            this.publicWorldBossTierList = new Vector.<PublicWorldBossTier>();
         }
         else
         {
            this.publicWorldBossTierList = param7;
         }
         this.timeToNextRaidSeconds = param5;
         this.raiding = param6;
         this.timeToEventEndSeconds = param4;
         this.currHealth = param1;
         this.maxHealth = param2;
         this.currTier = param3;
      }
      
      public static function get instance() : PublicWorldBossInfoCommand
      {
         return _instance || (_instance = new PublicWorldBossInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2610;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 41;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PublicWorldBossTier = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.publicWorldBossTierList.length > 0)
         {
            this.publicWorldBossTierList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = PublicWorldBossTier(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.publicWorldBossTierList.push(_loc4_);
            _loc2_++;
         }
         this.timeToNextRaidSeconds = param1.readDouble();
         this.raiding = param1.readBoolean();
         this.timeToEventEndSeconds = param1.readDouble();
         this.currHealth = param1.readDouble();
         this.maxHealth = param1.readDouble();
         this.currTier = param1.readInt();
         this.currTier = this.currTier << 16 % 32 | this.currTier >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PublicWorldBossTier = null;
         param1.writeShort(2610);
         param1.writeByte(this.publicWorldBossTierList.length);
         for each(_loc2_ in this.publicWorldBossTierList)
         {
            _loc2_.write(param1);
         }
         param1.writeDouble(this.timeToNextRaidSeconds);
         param1.writeBoolean(this.raiding);
         param1.writeDouble(this.timeToEventEndSeconds);
         param1.writeDouble(this.currHealth);
         param1.writeDouble(this.maxHealth);
         param1.writeInt(this.currTier >>> 16 % 32 | this.currTier << 32 - 16 % 32);
      }
   }
}

