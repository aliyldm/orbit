package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteDroneModule implements IModule
   {
      
      private static var _instance:RogueLiteDroneModule;
      
      public var lootId:String = "";
      
      public var equipments:Vector.<InventoryItemModule>;
      
      public var level:int = 0;
      
      public function RogueLiteDroneModule(param1:String = "", param2:int = 0, param3:Vector.<InventoryItemModule> = null)
      {
         super();
         this.lootId = param1;
         if(param3 == null)
         {
            this.equipments = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.equipments = param3;
         }
         this.level = param2;
      }
      
      public static function get instance() : RogueLiteDroneModule
      {
         return _instance || (_instance = new RogueLiteDroneModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9454;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:InventoryItemModule = null;
         this.lootId = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.equipments.length > 0)
         {
            this.equipments.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.equipments.push(_loc4_);
            _loc2_++;
         }
         this.level = param1.readInt();
         this.level = this.level >>> 10 % 32 | this.level << 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:InventoryItemModule = null;
         param1.writeShort(-9454);
         param1.writeUTF(this.lootId);
         param1.writeByte(this.equipments.length);
         for each(_loc2_ in this.equipments)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.level << 10 % 32 | this.level >>> 32 - 10 % 32);
      }
   }
}

