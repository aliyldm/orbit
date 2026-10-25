package net.bigpoint.darkorbit.com.module.porting.shop
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class ShopItemListCommand implements IModule
   {
      
      private static var _instance:ShopItemListCommand;
      
      public var category:String = "";
      
      public var promptList:Vector.<ShopLabelPrompt>;
      
      public var itemList:Vector.<ShopItemCommand>;
      
      public var currentShipLootId:String = "";
      
      public function ShopItemListCommand(param1:String = "", param2:String = "", param3:Vector.<ShopItemCommand> = null, param4:Vector.<ShopLabelPrompt> = null)
      {
         super();
         this.category = param1;
         if(param4 == null)
         {
            this.promptList = new Vector.<ShopLabelPrompt>();
         }
         else
         {
            this.promptList = param4;
         }
         if(param3 == null)
         {
            this.itemList = new Vector.<ShopItemCommand>();
         }
         else
         {
            this.itemList = param3;
         }
         this.currentShipLootId = param2;
      }
      
      public static function get instance() : ShopItemListCommand
      {
         return _instance || (_instance = new ShopItemListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 296;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ShopLabelPrompt = null;
         var _loc5_:ShopItemCommand = null;
         this.category = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.promptList.length > 0)
         {
            this.promptList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ShopLabelPrompt(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.promptList.push(_loc4_);
            _loc2_++;
         }
         while(this.itemList.length > 0)
         {
            this.itemList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = ShopItemCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.itemList.push(_loc5_);
            _loc2_++;
         }
         this.currentShipLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ShopLabelPrompt = null;
         var _loc3_:ShopItemCommand = null;
         param1.writeShort(296);
         param1.writeUTF(this.category);
         param1.writeByte(this.promptList.length);
         for each(_loc2_ in this.promptList)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.itemList.length);
         for each(_loc3_ in this.itemList)
         {
            _loc3_.write(param1);
         }
         param1.writeUTF(this.currentShipLootId);
      }
   }
}

