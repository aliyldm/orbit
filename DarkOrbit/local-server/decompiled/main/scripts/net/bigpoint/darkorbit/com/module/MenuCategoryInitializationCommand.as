package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MenuCategoryInitializationCommand implements IModule
   {
      
      private static var _instance:MenuCategoryInitializationCommand;
      
      public var menuItems:Vector.<MenuItemInitializationCommand>;
      
      public var categoryId:String = "";
      
      public function MenuCategoryInitializationCommand(param1:String = "", param2:Vector.<MenuItemInitializationCommand> = null)
      {
         super();
         if(param2 == null)
         {
            this.menuItems = new Vector.<MenuItemInitializationCommand>();
         }
         else
         {
            this.menuItems = param2;
         }
         this.categoryId = param1;
      }
      
      public static function get instance() : MenuCategoryInitializationCommand
      {
         return _instance || (_instance = new MenuCategoryInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3461;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:MenuItemInitializationCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.menuItems.length > 0)
         {
            this.menuItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = MenuItemInitializationCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.menuItems.push(_loc4_);
            _loc2_++;
         }
         this.categoryId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:MenuItemInitializationCommand = null;
         param1.writeShort(-3461);
         param1.writeByte(this.menuItems.length);
         for each(_loc2_ in this.menuItems)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.categoryId);
      }
   }
}

