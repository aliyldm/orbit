package net.bigpoint.darkorbit.mvc.crafting.assembly.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterSettingsVO;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.items.utils.ItemFilter;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.types.AssemblyTemporaryType;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class RecipeUserSettingsFilterProxy extends Proxy
   {
      
      public static const NAME:String = "RecipeUserSettingsFilterProxy";
      
      private var _filterSettingsVO:ItemFilterSettingsVO;
      
      public function RecipeUserSettingsFilterProxy()
      {
         super(NAME);
         this._filterSettingsVO = new ItemFilterSettingsVO(ItemFilter.getFilterByType(ItemFilter.FILTER_TYPE_ASSEMBLY),"ASSEMBLY");
         ItemFilterTypes.initialize();
      }
      
      public function get filterSettingsVO() : ItemFilterSettingsVO
      {
         return this._filterSettingsVO;
      }
      
      public function filter(param1:Vector.<AssemblyRecipeModel>) : Vector.<AssemblyRecipeModel>
      {
         return this.filterItems(param1,this._filterSettingsVO.getAllSelectedItemTypes(),this._filterSettingsVO.isEventFilterSelected());
      }
      
      protected function filterItems(param1:Vector.<AssemblyRecipeModel>, param2:Dictionary, param3:Boolean) : Vector.<AssemblyRecipeModel>
      {
         var _loc7_:AssemblyRecipeModel = null;
         var _loc4_:Vector.<AssemblyRecipeModel> = new Vector.<AssemblyRecipeModel>();
         var _loc5_:uint = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = param1[_loc6_];
            if(!(param3 && (_loc7_.attribute.visibility != "ON_SCHEDULE" || !(_loc7_.type is AssemblyTemporaryType))))
            {
               if(Boolean(param2[_loc7_.outPutItem.typeClass]) || Boolean(param2[_loc7_.outPutItem.typeClass + "." + _loc7_.outPutItem.typeValue]))
               {
                  _loc4_.push(_loc7_);
               }
            }
            _loc6_++;
         }
         return _loc4_;
      }
   }
}

