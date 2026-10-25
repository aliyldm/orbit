package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MenuItemStatusCommand implements IModule
   {
      
      private static var _instance:MenuItemStatusCommand;
      
      public static const COUNTERSTYLE_DEFAULT:int = 0;
      
      public static const COUNTERSTYLE_RED:int = 1;
      
      public static const COUNTERSTYLE_GREEN:int = 2;
      
      public static const COUNTERSTYLE_YELLOW:int = 3;
      
      public static const COUNTERSTYLE_BLUE:int = 4;
      
      public static const COUNTERSTYLE_CYAN:int = 5;
      
      public static const COUNTERSTYLE_ORANGE:int = 6;
      
      public static const COUNTERSTYLE__MAX:int = 7;
      
      public var visible:Boolean = false;
      
      public var selected:Boolean = false;
      
      public var toolTipSlotBar:MessageKeyListWildcardCommand;
      
      public var counterStyle:int = 0;
      
      public var blocked:Boolean = false;
      
      public var counterValue:Number = 0;
      
      public var activatable:Boolean = false;
      
      public var menuItemId:String = "";
      
      public var available:Boolean = false;
      
      public var toolTipItemBar:MessageKeyListWildcardCommand;
      
      public var buyable:Boolean = false;
      
      public var maxCounterValue:Number = 0;
      
      public var iconLootId:String = "";
      
      public function MenuItemStatusCommand(param1:Boolean = false, param2:Boolean = false, param3:String = "", param4:MessageKeyListWildcardCommand = null, param5:MessageKeyListWildcardCommand = null, param6:Boolean = false, param7:Number = 0, param8:Number = 0, param9:int = 0, param10:String = "", param11:Boolean = false, param12:Boolean = false, param13:Boolean = false)
      {
         super();
         this.visible = param2;
         this.selected = param12;
         if(param5 == null)
         {
            this.toolTipSlotBar = new MessageKeyListWildcardCommand();
         }
         else
         {
            this.toolTipSlotBar = param5;
         }
         this.counterStyle = param9;
         this.blocked = param13;
         this.counterValue = param8;
         this.activatable = param11;
         this.menuItemId = param3;
         this.available = param1;
         if(param4 == null)
         {
            this.toolTipItemBar = new MessageKeyListWildcardCommand();
         }
         else
         {
            this.toolTipItemBar = param4;
         }
         this.buyable = param6;
         this.maxCounterValue = param7;
         this.iconLootId = param10;
      }
      
      public static function get instance() : MenuItemStatusCommand
      {
         return _instance || (_instance = new MenuItemStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24049;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.visible = param1.readBoolean();
         this.selected = param1.readBoolean();
         this.toolTipSlotBar = MessageKeyListWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toolTipSlotBar)
         {
            this.toolTipSlotBar.read(param1);
         }
         this.counterStyle = param1.readShort();
         this.blocked = param1.readBoolean();
         this.counterValue = param1.readDouble();
         this.activatable = param1.readBoolean();
         this.menuItemId = param1.readUTF();
         this.available = param1.readBoolean();
         this.toolTipItemBar = MessageKeyListWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toolTipItemBar)
         {
            this.toolTipItemBar.read(param1);
         }
         this.buyable = param1.readBoolean();
         this.maxCounterValue = param1.readDouble();
         this.iconLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24049);
         param1.writeBoolean(this.visible);
         param1.writeBoolean(this.selected);
         if(null != this.toolTipSlotBar)
         {
            this.toolTipSlotBar.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.counterStyle);
         param1.writeBoolean(this.blocked);
         param1.writeDouble(this.counterValue);
         param1.writeBoolean(this.activatable);
         param1.writeUTF(this.menuItemId);
         param1.writeBoolean(this.available);
         if(null != this.toolTipItemBar)
         {
            this.toolTipItemBar.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.buyable);
         param1.writeDouble(this.maxCounterValue);
         param1.writeUTF(this.iconLootId);
      }
   }
}

