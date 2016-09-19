defmodule TurnstileTest do
  use ExUnit.Case
  doctest Turnstile

  setup do
    {:ok, turnstile} = Turnstile.start_link
    {:ok, turnstile: turnstile}
  end

  test "it starts locked", %{turnstile: turnstile} do
    assert Turnstile.is_locked?(turnstile)
  end

  test "it unlocks with a coin", %{turnstile: turnstile} do
    Turnstile.insert_coin(turnstile)
    refute Turnstile.is_locked?(turnstile)
  end

  test "it can only push when unlocked", %{turnstile: turnstile} do
    assert {:error, _reason} =  Turnstile.push(turnstile)
    Turnstile.insert_coin(turnstile)
    assert :ok = Turnstile.push(turnstile)
  end

  test "it locks after successful push", %{turnstile: turnstile} do
    assert Turnstile.is_locked?(turnstile)
    Turnstile.insert_coin(turnstile)
    refute Turnstile.is_locked?(turnstile)
    assert :ok = Turnstile.push(turnstile)
    assert Turnstile.is_locked?(turnstile)
  end
end
