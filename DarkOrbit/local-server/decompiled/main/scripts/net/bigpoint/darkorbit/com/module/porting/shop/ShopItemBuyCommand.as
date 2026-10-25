package net.bigpoint.darkorbit.com.module.porting.shop
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class ShopItemBuyCommand implements IModule
   {
      
      private static var _instance:ShopItemBuyCommand;
      
      public var canEquipItemId:Vector.<Number>;
      
      public var slotSet:String = "";
      
      public var hintEquipTo:String = "";
      
      public var canBeSubscribedTo:Boolean = false;
      
      public var userHasBoosterPackage:Boolean = false;
      
      public var buyCategory:String = "";
      
      public var resultId:int = 0;
      
      public var configId:int = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public var lootId:String = "";
      
      public var category:String = "";
      
      public var hangarId:Number = 0;
      
      public var realBuyAmount:int = 0;
      
      public var isSubscriptionRunning:Boolean = false;
      
      public var allowAutoEquip:int = 0;
      
      public var sucessMessage:BaseStackCommand;
      
      public var emptySlotCount:int = 0;
      
      public var droneId:Number = 0;
      
      public var isSubscriptionPaused:Boolean = false;
      
      public var secondsLeft:Number = 0;
      
      public var action:String = "";
      
      public function ShopItemBuyCommand(param1:int = 0, param2:String = "", param3:BaseStackCommand = null, param4:BaseStackCommand = null, param5:String = "", param6:String = "", param7:int = 0, param8:String = "", param9:Vector.<Number> = null, param10:int = 0, param11:Number = 0, param12:Number = 0, param13:String = "", param14:int = 0, param15:int = 0, param16:Boolean = false, param17:Boolean = false, param18:Boolean = false, param19:Boolean = false, param20:Number = 0, param21:String = "")
      {
         super();
         if(param9 == null)
         {
            this.canEquipItemId = new Vector.<Number>();
         }
         else
         {
            this.canEquipItemId = param9;
         }
         this.slotSet = param13;
         this.hintEquipTo = param8;
         this.canBeSubscribedTo = param16;
         this.userHasBoosterPackage = param19;
         this.buyCategory = param6;
         this.resultId = param1;
         this.configId = param14;
         if(param3 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param3;
         }
         this.lootId = param2;
         this.category = param5;
         this.hangarId = param11;
         this.realBuyAmount = param10;
         this.isSubscriptionRunning = param17;
         this.allowAutoEquip = param7;
         if(param4 == null)
         {
            this.sucessMessage = new BaseStackCommand();
         }
         else
         {
            this.sucessMessage = param4;
         }
         this.emptySlotCount = param15;
         this.droneId = param12;
         this.isSubscriptionPaused = param18;
         this.secondsLeft = param20;
         this.action = param21;
      }
      
      public static function get instance() : ShopItemBuyCommand
      {
         return _instance || (_instance = new ShopItemBuyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27788;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 64;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.canEquipItemId.length > 0)
         {
            this.canEquipItemId.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.canEquipItemId.push(param1.readDouble());
            _loc2_++;
         }
         this.slotSet = param1.readUTF();
         this.hintEquipTo = param1.readUTF();
         this.canBeSubscribedTo = param1.readBoolean();
         this.userHasBoosterPackage = param1.readBoolean();
         this.buyCategory = param1.readUTF();
         this.resultId = param1.readInt();
         this.resultId = this.resultId << 6 % 32 | this.resultId >>> 32 - 6 % 32;
         this.configId = param1.readInt();
         this.configId = this.configId << 1 % 32 | this.configId >>> 32 - 1 % 32;
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.lootId = param1.readUTF();
         this.category = param1.readUTF();
         this.hangarId = param1.readDouble();
         this.realBuyAmount = param1.readInt();
         this.realBuyAmount = this.realBuyAmount >>> 4 % 32 | this.realBuyAmount << 32 - 4 % 32;
         this.isSubscriptionRunning = param1.readBoolean();
         this.allowAutoEquip = param1.readInt();
         this.allowAutoEquip = this.allowAutoEquip << 10 % 32 | this.allowAutoEquip >>> 32 - 10 % 32;
         this.sucessMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.sucessMessage)
         {
            this.sucessMessage.read(param1);
         }
         this.emptySlotCount = param1.readInt();
         this.emptySlotCount = this.emptySlotCount << 11 % 32 | this.emptySlotCount >>> 32 - 11 % 32;
         this.droneId = param1.readDouble();
         this.isSubscriptionPaused = param1.readBoolean();
         this.secondsLeft = param1.readDouble();
         this.action = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:Number = NaN;
         param1.writeShort(27788);
         param1.writeByte(this.canEquipItemId.length);
         for each(_loc2_ in this.canEquipItemId)
         {
            param1.writeDouble(_loc2_);
         }
         param1.writeUTF(this.slotSet);
         param1.writeUTF(this.hintEquipTo);
         param1.writeBoolean(this.canBeSubscribedTo);
         param1.writeBoolean(this.userHasBoosterPackage);
         param1.writeUTF(this.buyCategory);
         param1.writeInt(this.resultId >>> 6 % 32 | this.resultId << 32 - 6 % 32);
         param1.writeInt(this.configId >>> 1 % 32 | this.configId << 32 - 1 % 32);
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.lootId);
         param1.writeUTF(this.category);
         param1.writeDouble(this.hangarId);
         param1.writeInt(this.realBuyAmount << 4 % 32 | this.realBuyAmount >>> 32 - 4 % 32);
         param1.writeBoolean(this.isSubscriptionRunning);
         param1.writeInt(this.allowAutoEquip >>> 10 % 32 | this.allowAutoEquip << 32 - 10 % 32);
         if(null != this.sucessMessage)
         {
            this.sucessMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.emptySlotCount >>> 11 % 32 | this.emptySlotCount << 32 - 11 % 32);
         param1.writeDouble(this.droneId);
         param1.writeBoolean(this.isSubscriptionPaused);
         param1.writeDouble(this.secondsLeft);
         param1.writeUTF(this.action);
      }
   }
}

