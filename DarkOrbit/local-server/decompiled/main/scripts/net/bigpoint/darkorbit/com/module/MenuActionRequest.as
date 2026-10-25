package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MenuActionRequest implements IModule
   {
      
      private static var _instance:MenuActionRequest;
      
      public static const SOURCETYPE_ITEM_BAR:int = 0;
      
      public static const SOURCETYPE_SLOT_BAR:int = 1;
      
      public static const SOURCETYPE__MAX:int = 2;
      
      public static const ACTIONTYPE_SELECT:int = 0;
      
      public static const ACTIONTYPE_ACTIVATE:int = 1;
      
      public static const ACTIONTYPE__MAX:int = 2;
      
      public var actionType:int = 0;
      
      public var sourceType:int = 0;
      
      public var menuItemId:String = "";
      
      public function MenuActionRequest(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.actionType = param2;
         this.sourceType = param3;
         this.menuItemId = param1;
      }
      
      public static function get instance() : MenuActionRequest
      {
         return _instance || (_instance = new MenuActionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8766;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.actionType = param1.readShort();
         this.sourceType = param1.readShort();
         this.menuItemId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(8766);
         param1.writeShort(this.actionType);
         param1.writeShort(this.sourceType);
         param1.writeUTF(this.menuItemId);
      }
   }
}

