package net.bigpoint.darkorbit.com.module.porting.cannon
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.*;
   
   public class CannonUnstableModuleModule extends UnstableModuleModule
   {
      
      private static var _instance:CannonUnstableModuleModule;
      
      public var upgradeReturns:Vector.<LootModule>;
      
      public var upgradeLevel:int = 0;
      
      public function CannonUnstableModuleModule(param1:Number = 0, param2:String = "", param3:Vector.<String> = null, param4:Vector.<UnstableAttributeModule> = null, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:Vector.<LootModule> = null, param10:Vector.<LootModule> = null, param11:int = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         if(param10 == null)
         {
            this.upgradeReturns = new Vector.<LootModule>();
         }
         else
         {
            this.upgradeReturns = param10;
         }
         this.upgradeLevel = param11;
      }
      
      public static function get instance() : CannonUnstableModuleModule
      {
         return _instance || (_instance = new CannonUnstableModuleModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 14378;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      override public function read(param1:IDataInput) : void
      {
         var _loc4_:LootModule = null;
         param1.readShort();
         super.read(param1);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.upgradeReturns.length > 0)
         {
            this.upgradeReturns.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LootModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.upgradeReturns.push(_loc4_);
            _loc2_++;
         }
         this.upgradeLevel = param1.readInt();
         this.upgradeLevel = this.upgradeLevel >>> 6 % 32 | this.upgradeLevel << 32 - 6 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         var _loc2_:LootModule = null;
         param1.writeShort(14378);
         super.write(param1);
         param1.writeByte(this.upgradeReturns.length);
         for each(_loc2_ in this.upgradeReturns)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.upgradeLevel << 6 % 32 | this.upgradeLevel >>> 32 - 6 % 32);
      }
   }
}

