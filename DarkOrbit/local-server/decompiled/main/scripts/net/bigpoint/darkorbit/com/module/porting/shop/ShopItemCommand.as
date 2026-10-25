package net.bigpoint.darkorbit.com.module.porting.shop
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ShopItemCommand implements IModule
   {
      
      private static var _instance:ShopItemCommand;
      
      public static const LIMITTYPE_none:int = 0;
      
      public static const LIMITTYPE_daily:int = 1;
      
      public static const LIMITTYPE_weekly:int = 2;
      
      public static const LIMITTYPE_monthly:int = 3;
      
      public static const LIMITTYPE_eventLimited:int = 4;
      
      public static const LIMITTYPE__MAX:int = 5;
      
      public var category:String = "";
      
      public var isServerExclusive:int = 0;
      
      public var price:Vector.<Number>;
      
      public var saleRemainingTime:Number = 0;
      
      public var amountsSelectable:String = "";
      
      public var canBeSubscribedTo:Boolean = false;
      
      public var isPaymentItem:int = 0;
      
      public var maxAmount:int = 0;
      
      public var lootId:String = "";
      
      public var buyMore:Boolean = false;
      
      public var isSubscriptionRunning:Boolean = false;
      
      public var currency:String = "";
      
      public var limitMax:int = 0;
      
      public var expiresSeconds:int = 0;
      
      public var limitType:int = 0;
      
      public var LevelDataList:Vector.<ShopItemLevelDataCommand>;
      
      public var isSubscriptionPaused:Boolean = false;
      
      public var isActiveEventItem:int = 0;
      
      public var elite:int = 0;
      
      public var discountPercent:String = "";
      
      public var userHasBoosterPackage:Boolean = false;
      
      public var limitAmount:int = 0;
      
      public var maxlevel:int = 0;
      
      public var levelGrades:String = "";
      
      public var cost:String = "";
      
      public var secondsLeft:Number = 0;
      
      public function ShopItemCommand(param1:String = "", param2:String = "", param3:Vector.<Number> = null, param4:int = 0, param5:Number = 0, param6:int = 0, param7:String = "", param8:int = 0, param9:int = 0, param10:String = "", param11:String = "", param12:String = "", param13:String = "", param14:int = 0, param15:Boolean = false, param16:int = 0, param17:Vector.<ShopItemLevelDataCommand> = null, param18:Boolean = false, param19:Boolean = false, param20:Boolean = false, param21:Boolean = false, param22:Number = 0, param23:int = 0, param24:int = 0, param25:int = 0, param26:int = 0)
      {
         super();
         this.category = param2;
         this.isServerExclusive = param8;
         if(param3 == null)
         {
            this.price = new Vector.<Number>();
         }
         else
         {
            this.price = param3;
         }
         this.saleRemainingTime = param5;
         this.amountsSelectable = param12;
         this.canBeSubscribedTo = param18;
         this.isPaymentItem = param9;
         this.maxAmount = param14;
         this.lootId = param1;
         this.buyMore = param15;
         this.isSubscriptionRunning = param19;
         this.currency = param11;
         this.limitMax = param25;
         this.expiresSeconds = param26;
         this.limitType = param23;
         if(param17 == null)
         {
            this.LevelDataList = new Vector.<ShopItemLevelDataCommand>();
         }
         else
         {
            this.LevelDataList = param17;
         }
         this.isSubscriptionPaused = param20;
         this.isActiveEventItem = param6;
         this.elite = param4;
         this.discountPercent = param10;
         this.userHasBoosterPackage = param21;
         this.limitAmount = param24;
         this.maxlevel = param16;
         this.levelGrades = param13;
         this.cost = param7;
         this.secondsLeft = param22;
      }
      
      public static function get instance() : ShopItemCommand
      {
         return _instance || (_instance = new ShopItemCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -23042;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 79;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ShopItemLevelDataCommand = null;
         this.category = param1.readUTF();
         this.isServerExclusive = param1.readInt();
         this.isServerExclusive = this.isServerExclusive << 14 % 32 | this.isServerExclusive >>> 32 - 14 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.price.length > 0)
         {
            this.price.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.price.push(param1.readFloat());
            _loc2_++;
         }
         this.saleRemainingTime = param1.readDouble();
         this.amountsSelectable = param1.readUTF();
         this.canBeSubscribedTo = param1.readBoolean();
         this.isPaymentItem = param1.readInt();
         this.isPaymentItem = this.isPaymentItem << 7 % 32 | this.isPaymentItem >>> 32 - 7 % 32;
         this.maxAmount = param1.readInt();
         this.maxAmount = this.maxAmount >>> 7 % 32 | this.maxAmount << 32 - 7 % 32;
         this.lootId = param1.readUTF();
         this.buyMore = param1.readBoolean();
         this.isSubscriptionRunning = param1.readBoolean();
         this.currency = param1.readUTF();
         this.limitMax = param1.readInt();
         this.limitMax = this.limitMax << 4 % 32 | this.limitMax >>> 32 - 4 % 32;
         this.expiresSeconds = param1.readInt();
         this.expiresSeconds = this.expiresSeconds >>> 8 % 32 | this.expiresSeconds << 32 - 8 % 32;
         this.limitType = param1.readShort();
         while(this.LevelDataList.length > 0)
         {
            this.LevelDataList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ShopItemLevelDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.LevelDataList.push(_loc4_);
            _loc2_++;
         }
         this.isSubscriptionPaused = param1.readBoolean();
         this.isActiveEventItem = param1.readInt();
         this.isActiveEventItem = this.isActiveEventItem >>> 15 % 32 | this.isActiveEventItem << 32 - 15 % 32;
         this.elite = param1.readInt();
         this.elite = this.elite << 7 % 32 | this.elite >>> 32 - 7 % 32;
         this.discountPercent = param1.readUTF();
         this.userHasBoosterPackage = param1.readBoolean();
         this.limitAmount = param1.readInt();
         this.limitAmount = this.limitAmount << 11 % 32 | this.limitAmount >>> 32 - 11 % 32;
         this.maxlevel = param1.readInt();
         this.maxlevel = this.maxlevel << 13 % 32 | this.maxlevel >>> 32 - 13 % 32;
         this.levelGrades = param1.readUTF();
         this.cost = param1.readUTF();
         this.secondsLeft = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:ShopItemLevelDataCommand = null;
         param1.writeShort(-23042);
         param1.writeUTF(this.category);
         param1.writeInt(this.isServerExclusive >>> 14 % 32 | this.isServerExclusive << 32 - 14 % 32);
         param1.writeByte(this.price.length);
         for each(_loc2_ in this.price)
         {
            param1.writeFloat(_loc2_);
         }
         param1.writeDouble(this.saleRemainingTime);
         param1.writeUTF(this.amountsSelectable);
         param1.writeBoolean(this.canBeSubscribedTo);
         param1.writeInt(this.isPaymentItem >>> 7 % 32 | this.isPaymentItem << 32 - 7 % 32);
         param1.writeInt(this.maxAmount << 7 % 32 | this.maxAmount >>> 32 - 7 % 32);
         param1.writeUTF(this.lootId);
         param1.writeBoolean(this.buyMore);
         param1.writeBoolean(this.isSubscriptionRunning);
         param1.writeUTF(this.currency);
         param1.writeInt(this.limitMax >>> 4 % 32 | this.limitMax << 32 - 4 % 32);
         param1.writeInt(this.expiresSeconds << 8 % 32 | this.expiresSeconds >>> 32 - 8 % 32);
         param1.writeShort(this.limitType);
         param1.writeByte(this.LevelDataList.length);
         for each(_loc3_ in this.LevelDataList)
         {
            _loc3_.write(param1);
         }
         param1.writeBoolean(this.isSubscriptionPaused);
         param1.writeInt(this.isActiveEventItem << 15 % 32 | this.isActiveEventItem >>> 32 - 15 % 32);
         param1.writeInt(this.elite >>> 7 % 32 | this.elite << 32 - 7 % 32);
         param1.writeUTF(this.discountPercent);
         param1.writeBoolean(this.userHasBoosterPackage);
         param1.writeInt(this.limitAmount >>> 11 % 32 | this.limitAmount << 32 - 11 % 32);
         param1.writeInt(this.maxlevel >>> 13 % 32 | this.maxlevel << 32 - 13 % 32);
         param1.writeUTF(this.levelGrades);
         param1.writeUTF(this.cost);
         param1.writeDouble(this.secondsLeft);
      }
   }
}

