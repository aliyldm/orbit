package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.utils
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class WorldBossListedVO
   {
      
      protected var _itemVoA:ItemVO;
      
      protected var _itemVoB:ItemVO;
      
      protected var _itemVoC:ItemVO;
      
      public function WorldBossListedVO()
      {
         super();
      }
      
      public function get itemVoA() : ItemVO
      {
         return this._itemVoA;
      }
      
      public function get itemVoB() : ItemVO
      {
         return this._itemVoB;
      }
      
      public function get itemVoC() : ItemVO
      {
         return this._itemVoC;
      }
   }
}

