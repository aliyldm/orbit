package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UnstableModuleModule implements IModule
   {
      
      private static var _instance:UnstableModuleModule;
      
      public var recycleReturns:int = 0;
      
      public var rerollsMax:int = 0;
      
      public var rerollCost:int = 0;
      
      public var rerollsLeft:int = 0;
      
      public var retainCost:Vector.<LootModule>;
      
      public var attributes:Vector.<UnstableAttributeModule>;
      
      public var shipDesigns:Vector.<String>;
      
      public var itemId:Number = 0;
      
      public var lootId:String = "";
      
      public function UnstableModuleModule(param1:Number = 0, param2:String = "", param3:Vector.<String> = null, param4:Vector.<UnstableAttributeModule> = null, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:Vector.<LootModule> = null)
      {
         super();
         this.recycleReturns = param8;
         this.rerollsMax = param5;
         this.rerollCost = param7;
         this.rerollsLeft = param6;
         if(param9 == null)
         {
            this.retainCost = new Vector.<LootModule>();
         }
         else
         {
            this.retainCost = param9;
         }
         if(param4 == null)
         {
            this.attributes = new Vector.<UnstableAttributeModule>();
         }
         else
         {
            this.attributes = param4;
         }
         if(param3 == null)
         {
            this.shipDesigns = new Vector.<String>();
         }
         else
         {
            this.shipDesigns = param3;
         }
         this.itemId = param1;
         this.lootId = param2;
      }
      
      public static function get instance() : UnstableModuleModule
      {
         return _instance || (_instance = new UnstableModuleModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 22318;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 38;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LootModule = null;
         var _loc5_:UnstableAttributeModule = null;
         this.recycleReturns = param1.readInt();
         this.recycleReturns = this.recycleReturns << 13 % 32 | this.recycleReturns >>> 32 - 13 % 32;
         this.rerollsMax = param1.readInt();
         this.rerollsMax = this.rerollsMax << 3 % 32 | this.rerollsMax >>> 32 - 3 % 32;
         this.rerollCost = param1.readInt();
         this.rerollCost = this.rerollCost >>> 3 % 32 | this.rerollCost << 32 - 3 % 32;
         this.rerollsLeft = param1.readInt();
         this.rerollsLeft = this.rerollsLeft >>> 8 % 32 | this.rerollsLeft << 32 - 8 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.retainCost.length > 0)
         {
            this.retainCost.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LootModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.retainCost.push(_loc4_);
            _loc2_++;
         }
         while(this.attributes.length > 0)
         {
            this.attributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = UnstableAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.attributes.push(_loc5_);
            _loc2_++;
         }
         while(this.shipDesigns.length > 0)
         {
            this.shipDesigns.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.shipDesigns.push(param1.readUTF());
            _loc2_++;
         }
         this.itemId = param1.readDouble();
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LootModule = null;
         var _loc3_:UnstableAttributeModule = null;
         var _loc4_:String = null;
         param1.writeShort(22318);
         param1.writeInt(this.recycleReturns >>> 13 % 32 | this.recycleReturns << 32 - 13 % 32);
         param1.writeInt(this.rerollsMax >>> 3 % 32 | this.rerollsMax << 32 - 3 % 32);
         param1.writeInt(this.rerollCost << 3 % 32 | this.rerollCost >>> 32 - 3 % 32);
         param1.writeInt(this.rerollsLeft << 8 % 32 | this.rerollsLeft >>> 32 - 8 % 32);
         param1.writeByte(this.retainCost.length);
         for each(_loc2_ in this.retainCost)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.attributes.length);
         for each(_loc3_ in this.attributes)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.shipDesigns.length);
         for each(_loc4_ in this.shipDesigns)
         {
            param1.writeUTF(_loc4_);
         }
         param1.writeDouble(this.itemId);
         param1.writeUTF(this.lootId);
      }
   }
}

