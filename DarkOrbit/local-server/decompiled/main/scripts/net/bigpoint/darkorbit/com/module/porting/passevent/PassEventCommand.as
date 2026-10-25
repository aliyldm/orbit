package net.bigpoint.darkorbit.com.module.porting.passevent
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class PassEventCommand implements IModule
   {
      
      private static var _instance:PassEventCommand;
      
      public var isVip:Boolean = false;
      
      public var normalItemList:Vector.<PassItemModule>;
      
      public var vipItemList:Vector.<PassItemModule>;
      
      public var currentLevel:int = 0;
      
      public var vipParams:Vector.<int>;
      
      public var remainSeconds:int = 0;
      
      public var nextLevelExp:int = 0;
      
      public var currentExp:int = 0;
      
      public function PassEventCommand(param1:Boolean = false, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Vector.<PassItemModule> = null, param7:Vector.<PassItemModule> = null, param8:Vector.<int> = null)
      {
         super();
         this.isVip = param1;
         if(param6 == null)
         {
            this.normalItemList = new Vector.<PassItemModule>();
         }
         else
         {
            this.normalItemList = param6;
         }
         if(param7 == null)
         {
            this.vipItemList = new Vector.<PassItemModule>();
         }
         else
         {
            this.vipItemList = param7;
         }
         this.currentLevel = param2;
         if(param8 == null)
         {
            this.vipParams = new Vector.<int>();
         }
         else
         {
            this.vipParams = param8;
         }
         this.remainSeconds = param5;
         this.nextLevelExp = param4;
         this.currentExp = param3;
      }
      
      public static function get instance() : PassEventCommand
      {
         return _instance || (_instance = new PassEventCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16338;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 29;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PassItemModule = null;
         var _loc5_:PassItemModule = null;
         var _loc6_:int = 0;
         this.isVip = param1.readBoolean();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.normalItemList.length > 0)
         {
            this.normalItemList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = PassItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.normalItemList.push(_loc4_);
            _loc2_++;
         }
         while(this.vipItemList.length > 0)
         {
            this.vipItemList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = PassItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.vipItemList.push(_loc5_);
            _loc2_++;
         }
         this.currentLevel = param1.readInt();
         this.currentLevel = this.currentLevel << 10 % 32 | this.currentLevel >>> 32 - 10 % 32;
         while(this.vipParams.length > 0)
         {
            this.vipParams.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1.readInt();
            _loc6_ = _loc6_ << 8 % 32 | _loc6_ >>> 32 - 8 % 32;
            this.vipParams.push(_loc6_);
            _loc2_++;
         }
         this.remainSeconds = param1.readInt();
         this.remainSeconds = this.remainSeconds << 6 % 32 | this.remainSeconds >>> 32 - 6 % 32;
         this.nextLevelExp = param1.readInt();
         this.nextLevelExp = this.nextLevelExp << 7 % 32 | this.nextLevelExp >>> 32 - 7 % 32;
         this.currentExp = param1.readInt();
         this.currentExp = this.currentExp << 3 % 32 | this.currentExp >>> 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PassItemModule = null;
         var _loc3_:PassItemModule = null;
         var _loc4_:int = 0;
         param1.writeShort(-16338);
         param1.writeBoolean(this.isVip);
         param1.writeByte(this.normalItemList.length);
         for each(_loc2_ in this.normalItemList)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.vipItemList.length);
         for each(_loc3_ in this.vipItemList)
         {
            _loc3_.write(param1);
         }
         param1.writeInt(this.currentLevel >>> 10 % 32 | this.currentLevel << 32 - 10 % 32);
         param1.writeByte(this.vipParams.length);
         for each(_loc4_ in this.vipParams)
         {
            param1.writeInt(_loc4_ >>> 8 % 32 | _loc4_ << 32 - 8 % 32);
         }
         param1.writeInt(this.remainSeconds >>> 6 % 32 | this.remainSeconds << 32 - 6 % 32);
         param1.writeInt(this.nextLevelExp >>> 7 % 32 | this.nextLevelExp << 32 - 7 % 32);
         param1.writeInt(this.currentExp >>> 3 % 32 | this.currentExp << 32 - 3 % 32);
      }
   }
}

